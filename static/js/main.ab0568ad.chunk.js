(this["webpackJsonpminions-managed"]=this["webpackJsonpminions-managed"]||[]).push([[0],{28:function(e,t,n){e.exports=n(82)},33:function(e,t,n){},81:function(e,t,n){},82:function(e,t,n){"use strict";n.r(t);var o=n(0),r=n.n(o),a=n(7),s=n.n(a),c=(n(33),n(22)),i=n(23),l=n(26),u=n(24),d=n(27),f=n(25),v=n.n(f),h=(n(80),function(e){var t=e.observations,n=[{dataField:"observed",text:"last observed",sort:!0},{dataField:"workerType",text:"worker type",sort:!0}],o=Object.keys(t).map((function(e){var o={workerType:e,observed:t[e]["collect-software-versions"]["iteration-1"].task.runs[0].resolved};return Object.keys(t[e]["collect-software-versions"]["iteration-1"]).forEach((function(r){r.includes("-version")&&(o[r]=t[e]["collect-software-versions"]["iteration-1"][r],n.some((function(e){return e.dataField===r}))||n.push({dataField:r,text:r.replace("-version","").replace("-major","").replace("-"," "),sort:!0}))})),o}));return r.a.createElement("div",null,r.a.createElement(v.a,{keyField:"workerType",data:o,columns:n,bootstrap4:!0}))}),p=(n(81),function(e){function t(){var e;return Object(c.a)(this,t),(e=Object(l.a)(this,Object(u.a)(t).call(this))).state={observations:{}},e}return Object(d.a)(t,e),Object(i.a)(t,[{key:"componentDidMount",value:function(){var e=this;fetch("https://index.taskcluster.net/v1/task/project.releng.a2ff8966607583fbc1944fccc256a80c.decision").then((function(e){return e.json()})).then((function(t){fetch("https://taskcluster-artifacts.net/"+t.taskId+"/0/public/results.json").then((function(e){return e.json()})).then((function(t){e.setState({observations:t})})).catch(console.log)})).catch(console.log)}},{key:"render",value:function(){return r.a.createElement(h,{observations:this.state.observations})}}]),t}(o.Component));Boolean("localhost"===window.location.hostname||"[::1]"===window.location.hostname||window.location.hostname.match(/^127(?:\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$/));s.a.render(r.a.createElement(p,null),document.getElementById("root")),"serviceWorker"in navigator&&navigator.serviceWorker.ready.then((function(e){e.unregister()}))}},[[28,1,2]]]);
//# sourceMappingURL=main.ab0568ad.chunk.js.map