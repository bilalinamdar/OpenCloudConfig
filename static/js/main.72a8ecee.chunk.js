(this["webpackJsonpminions-managed"]=this["webpackJsonpminions-managed"]||[]).push([[0],{28:function(e,t,n){e.exports=n(82)},33:function(e,t,n){},81:function(e,t,n){},82:function(e,t,n){"use strict";n.r(t);var r=n(0),a=n.n(r),o=n(7),c=n.n(o),s=(n(33),n(23)),i=n(24),l=n(26),u=n(25),d=n(27),f=n(12),p=n.n(f),h=(n(80),function(e){var t=e.observations,n=[{dataField:"time",text:"last observed",sort:!0},{dataField:"worker",text:"observed on",sort:!0},{dataField:"workerType",text:"worker type",sort:!0}],r=Object.keys(t).map((function(e){var r={workerType:e,time:t[e]["collect-software-versions"]["iteration-1"].task.runs[0].resolved,worker:t[e]["collect-software-versions"]["iteration-1"].task.runs[0].workerId};return Object.keys(t[e]["collect-software-versions"]["iteration-1"]).forEach((function(a){a.includes("-version")&&(r[a]=t[e]["collect-software-versions"]["iteration-1"][a],n.some((function(e){return e.dataField===a}))||n.push({dataField:a,text:a.replace("-version","").replace("-major","").replace("-"," "),sort:!0}))})),r})),o=[{dataField:"time",text:"last observed",sort:!0},{dataField:"worker",text:"observed on",sort:!0},{dataField:"workerType",text:"worker type",sort:!0}],c=Object.keys(t).map((function(e){var n=t[e].hasOwnProperty("collect-ronin-config")?"collect-ronin-config":t[e].hasOwnProperty("collect-occ-config")?"collect-occ-config":"undefined",r={};return"undefined"!==n?(r={workerType:e,time:t[e][n]["iteration-1"].task.runs[0].resolved,worker:t[e][n]["iteration-1"].task.runs[0].workerId},Object.keys(t[e][n]["iteration-1"]).forEach((function(a){a.includes("-source-")&&(r[a.replace("occ-"," ").replace("ronin-"," ")]=t[e][n]["iteration-1"][a],o.some((function(e){return e.dataField===a.replace("occ-"," ").replace("ronin-"," ")}))||o.push({dataField:a.replace("occ-"," ").replace("ronin-"," "),text:a.replace("occ-"," ").replace("ronin-"," ").replace("-"," "),sort:!0}))}))):r={workerType:e},r}));return a.a.createElement("div",{class:"container-fluid"},a.a.createElement("h2",null,"software version observations"),a.a.createElement(p.a,{keyField:"workerType",data:r,columns:n,bootstrap4:!0}),a.a.createElement("h2",null,"bootstrap config observations"),a.a.createElement(p.a,{keyField:"workerType",data:c,columns:o,bootstrap4:!0}),a.a.createElement("p",null,"data is harvested using taskcluster tasks defined at: ",a.a.createElement("a",{href:"https://gist.github.com/grenade/a2ff8966607583fbc1944fccc256a80c"},"https://gist.github.com/grenade/a2ff8966607583fbc1944fccc256a80c"),a.a.createElement("br",null),"latest tasks are determined by the task index at: ",a.a.createElement("a",{href:"https://tools.taskcluster.net/index/project.releng.a2ff8966607583fbc1944fccc256a80c.decision"},"https://tools.taskcluster.net/index/project.releng.a2ff8966607583fbc1944fccc256a80c.decision"),a.a.createElement("br",null),"rendering is done using react components at: ",a.a.createElement("a",{href:"https://github.com/grenade/minions-managed"},"https://github.com/grenade/minions-managed"),a.a.createElement("br",null),"pages are hosted using github pages at: ",a.a.createElement("a",{href:"https://github.com/mozilla-releng/OpenCloudConfig/tree/gh-pages"},"https://github.com/mozilla-releng/OpenCloudConfig/tree/gh-pages")))}),m=(n(81),function(e){function t(){var e;return Object(s.a)(this,t),(e=Object(l.a)(this,Object(u.a)(t).call(this))).state={observations:{}},e}return Object(d.a)(t,e),Object(i.a)(t,[{key:"componentDidMount",value:function(){var e=this;fetch("https://index.taskcluster.net/v1/task/project.releng.a2ff8966607583fbc1944fccc256a80c.decision").then((function(e){return e.json()})).then((function(t){fetch("https://taskcluster-artifacts.net/"+t.taskId+"/0/public/results.json").then((function(e){return e.json()})).then((function(t){e.setState({observations:t})})).catch(console.log)})).catch(console.log)}},{key:"render",value:function(){return a.a.createElement(h,{observations:this.state.observations})}}]),t}(r.Component));Boolean("localhost"===window.location.hostname||"[::1]"===window.location.hostname||window.location.hostname.match(/^127(?:\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$/));c.a.render(a.a.createElement(m,null),document.getElementById("root")),"serviceWorker"in navigator&&navigator.serviceWorker.ready.then((function(e){e.unregister()}))}},[[28,1,2]]]);
//# sourceMappingURL=main.72a8ecee.chunk.js.map