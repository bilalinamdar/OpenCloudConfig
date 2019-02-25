#!/bin/bash

tooltool_token_path=${HOME}/.tooltool.token
tooltool_url="https://tooltool.mozilla-releng.net"
current_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
current_script_name=$(basename ${0##*/} .sh)
#tmp_dir=$(mktemp -d)
tmp_dir=/tmp/${current_script_name}

fg_black=`tput setaf 0`
fg_red=`tput setaf 1`
fg_green=`tput setaf 2`
fg_yellow=`tput setaf 3`
fg_blue=`tput setaf 4`
fg_magenta=`tput setaf 5`
fg_cyan=`tput setaf 6`
fg_white=`tput setaf 7`
reset=`tput sgr0`

if [ ! -f "${tmp_dir}/tooltool.py" ]; then
  curl -o ${tmp_dir}/tooltool.py https://raw.githubusercontent.com/mozilla/build-tooltool/master/tooltool.py
  echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} tooltool client downloaded to ${tmp_dir}/tooltool.py"
fi

for manifest in $(ls ${current_script_dir}/../userdata/Manifest/gecko-*.json); do
  json=$(basename $manifest)
  mkdir -p ${tmp_dir}/${json%.*}/ExeInstall ${tmp_dir}/${json%.*}/MsiInstall ${tmp_dir}/${json%.*}/MsuInstall ${tmp_dir}/${json%.*}/ZipInstall ${tmp_dir}/${json%.*}/FileDownload ${tmp_dir}/${json%.*}/ChecksumFileDownload
  echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} $(tput bold)${fg_magenta}${json%.*}${reset}"
  for ComponentType in ExeInstall MsiInstall MsuInstall ZipInstall FileDownload ChecksumFileDownload; do
    jq --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType) | .ComponentName' ${manifest} | while read ComponentName; do
      echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} $(tput bold)${fg_magenta}${json%.*}${reset} ${ComponentType} ${ComponentName}"
      case "${ComponentType}" in
        ExeInstall)
          www_url=$(jq --arg ComponentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $ComponentName) | .Url' ${manifest})
          filename=${www_url##*/}
          savepath=${tmp_dir}/${json%.*}/${ComponentType}/${ComponentName}.exe
          ;;
        MsiInstall)
          www_url=$(jq --arg ComponentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $ComponentName) | .Url' ${manifest})
          product_id=$(jq --arg componentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $componentName) | .ProductId' ${manifest})
          filename=${www_url##*/}
          savepath=${tmp_dir}/${json%.*}/${ComponentType}/${product_id}.msi
          ;;
        MsuInstall)
          www_url=$(jq --arg ComponentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $ComponentName) | .Url' ${manifest})
          filename=${www_url##*/}
          savepath=${tmp_dir}/${json%.*}/${ComponentType}/${ComponentName}.msu
          ;;
        ZipInstall)
          www_url=$(jq --arg ComponentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $ComponentName) | .Url' ${manifest})
          filename=${www_url##*/}
          savepath=${tmp_dir}/${json%.*}/${ComponentType}/${ComponentName}.zip
          ;;
        FileDownload)
          www_url=$(jq --arg ComponentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $ComponentName) | .Source' ${manifest})
          target=$(jq --arg componentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $componentName) | .Target' ${manifest})
          filename=${target##*\\}
          savepath=${tmp_dir}/${json%.*}/${ComponentType}/${filename}
          ;;
        ChecksumFileDownload)
          www_url=$(jq --arg ComponentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $ComponentName) | .Source' ${manifest})
          target=$(jq --arg componentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $componentName) | .Target' ${manifest})
          filename=${target##*\\}
          savepath=${tmp_dir}/${json%.*}/${ComponentType}/${filename}
          ;;
      esac
      manifest_sha512=$(jq --arg ComponentName ${ComponentName} --arg componentType ${ComponentType} -r '.Components[] | select(.ComponentType == $componentType and .ComponentName == $ComponentName) | .sha512' ${manifest})
      echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} ${fg_white}${filename}${reset}"
      echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")] source: ${www_url}${reset}"
      echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")] target: ${savepath}${reset}"

      # check if we have a sha in the manifest
      if [ -z "${manifest_sha512}" ] || [ "${manifest_sha512}" == "null" ]; then
        echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")] sha512: not set ${reset}"
        
        if [ -f "${savepath}" ] && [ -s "${savepath}" ]; then
          # detected
          echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} detected ${savepath} ($(stat -c '%s' "${savepath}" | numfmt --to=si --suffix=B))"
        elif curl -sL -o "${savepath}" ${www_url} && [ -f "${savepath}" ] && [ -s "${savepath}" ]; then
          # downloaded
          echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} downloaded ${savepath} ($(stat -c '%s' "${savepath}" | numfmt --to=si --suffix=B)) from ${www_url}"
        fi
        # compute sha, add to manifest (everywhere that has same url and no sha)
        if [ -f "${savepath}" ] && [ -s "${savepath}" ]; then
          computed_sha512=$(sha512sum "${savepath}" | { read sha512 _; echo ${sha512}; })
          echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} ${fg_yellow}sha512: ${computed_sha512} computed${reset}"

          if curl --header "Authorization: Bearer $(cat ${tooltool_token_path})" --output /dev/null --silent --head --fail ${tooltool_url}/sha512/${computed_sha512}; then
            echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")] artifact is available in tooltool ${reset}"
          else
            echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} ${fg_yellow}artifact is not available in tooltool ${reset}"

            work_dir=$(pwd)
            cd ${tmp_dir}/${json%.*}/${ComponentType}
            python ${tmp_dir}/tooltool.py add --visibility internal "${savepath}" -m ${computed_sha512}.tt
            if python ${tmp_dir}/tooltool.py validate -m ${computed_sha512}.tt; then
              python ${tmp_dir}/tooltool.py upload --url ${tooltool_url} --authentication-file=${tooltool_token_path} --message "Bug 1342892 - OCC component: ${filename}" -m ${computed_sha512}.tt
              echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} ${filename} uploaded to tooltool with sha ${computed_sha512}"
              rm -f ${computed_sha512}.tt
            else
              echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} ${filename} upload skipped due to manifest validation failure for ${computed_sha512}.tt"
            fi
            cd ${work_dir}
          fi

          for open_for_edit_manifest in $(ls ${current_script_dir}/../userdata/Manifest/gecko-*.json); do
            echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} updating ${open_for_edit_manifest}..."
            # todo: implement manifest updating
          done;
          cp "${savepath}" ${tmp_dir}/${computed_sha512}
          exit 1
        fi
      else
        echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")] sha512: ${manifest_sha512} detected in manifest${reset}"

        if [ -f ${tmp_dir}/${manifest_sha512} ] && [ -s ${tmp_dir}/${manifest_sha512} ]; then
          echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")] skipping checks as this component was validated earlier${reset}"
          exit 0
        fi

        # download from url specified by manifest component, check the downloaded file exists and has a nonzero size
        if curl -sL -o "${savepath}" "${www_url}" && [ -f "${savepath}" ] && [ -s "${savepath}" ]; then
          echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} downloaded ${savepath} ($(stat -c '%s' "${savepath}" | numfmt --to=si --suffix=B)) from ${www_url}"
          cp "${savepath}" ${tmp_dir}/${manifest_sha512}
        elif [ ! -f "${savepath}" ]; then
          echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} ${fg_red}${savepath} download from ${www_url} failed${reset}"
          # since we have a sha in the manifest, try a tooltool download
          if curl --header "Authorization: Bearer $(cat ${tooltool_token_path})" --output /dev/null --silent --head --fail ${tooltool_url}/sha512/${manifest_sha512}; then
            echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")] artifact is available from tooltool ${reset}"
            if curl --header "Authorization: Bearer $(cat ${tooltool_token_path})" -sL -o "${savepath}" ${tooltool_url}/sha512/${manifest_sha512} && [ -f "${savepath}" ] && [ -s "${savepath}" ]; then
              echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} downloaded ${savepath} ($(stat -c '%s' "${savepath}" | numfmt --to=si --suffix=B)) from ${tooltool_url}/sha512/${manifest_sha512}"
              cp "${savepath}" ${tmp_dir}/${manifest_sha512}
            fi
          fi
        fi
        if [ -f "${savepath}" ] && [ -s "${savepath}" ]; then
          computed_sha512=$(sha512sum "${savepath}" | { read sha512 _; echo ${sha512}; })
          if [ "${computed_sha512}" == "${manifest_sha512}" ]; then
            echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} computed sha matches manifest sha ${manifest_sha512:0:12}...${manifest_sha512: -12}"
          else
            echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} ${fg_red}computed sha ${computed_sha512:0:12}...${computed_sha512: -12} conflicts with manifest sha ${manifest_sha512:0:12}...${manifest_sha512: -12}${reset}"
            exit 1
          fi
          
        else
          echo "$(tput dim)[${current_script_name} $(date --utc +"%F %T.%3NZ")]${reset} ${fg_red}failed to download artifact from any source${reset}"
          exit
        fi
      fi
    done
    [[ $? != 0 ]] && exit $?
  done
  [[ $? != 0 ]] && exit $?
done
