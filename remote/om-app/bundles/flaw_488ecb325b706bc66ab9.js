webpackJsonp([6],{0:function(e,t,a){e.exports=a(1327)},1327:function(e,t,a){"use strict";function n(e){return e&&e.__esModule?e:{default:e}}function i(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}function o(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}function l(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}var r=a(430),s=n(r),d=a(357),c=n(d),m=function(){function e(e,t){for(var a=0;a<t.length;a++){var n=t[a];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}return function(t,a,n){return a&&e(t.prototype,a),n&&e(t,n),t}}();a(1328),a(1331);var f=a(2),p=n(f),u=a(5),_=n(u);a(15);var h=a(9),g=n(h),x=a(1337),w=n(x),b=a(1344),y=n(b),v=(a(178),a(24)),k=a(157),D=function(e){function t(){i(this,t);var e=o(this,(t.__proto__||Object.getPrototypeOf(t)).call(this));e.getFaultLevelList=function(t){if(!(e.state.loading||"2"===t&&e.state.totalPage&&e.state.page>=e.state.totalPage)){"1"===t&&e.setState({refreshing:!0,page:1});var a=e.state,n=a.faultLevel,i=a.processState,o=(a.stationName,a.siteId,a.stationList,a.page),l=a.limit;n==-1&&(n="");var r={powerstationId:(0,v.getQueryString)("siteId")||localStorage.getItem("powerStationId")||"",faultLevel:String(n),processState:0===i?"":i,page:"2"===t?o+1:1,limit:l};e.setState({loading:!0}),(0,v.api)("s-solaromds/app/op/fault/list",r,"POST").then(function(a){var n=a.list;if(e.state.dataSource)if("2"===t){var i=e.state.faultLevelList.concat(n);e.setState({dataSource:e.state.dataSource.cloneWithRows(i),faultLevelList:i,page:o+1,totalPage:a.totalPage,loading:!1})}else e.setState({dataSource:e.state.dataSource.cloneWithRows(n),faultLevelList:n,page:1,totalPage:a.totalPage,loading:!1});"1"===t&&e.setState({refreshing:!1})})}};var a=new c.default.DataSource({rowHasChanged:function(e,t){return e!==t}});return e.state={dataSource:a,currentPeople:0,currentType:0,showSort:!1,showSelect:!1,faultLevelList:[],stationList:[],faultLevel:-1,processState:0,stationName:0,showEmpty:!1,siteId:(0,v.getQueryString)("siteId")||localStorage.getItem("powerStationId")||"",page:1,limit:10,workTypes:null,refreshing:!1},e.changePeople=e.changePeople.bind(e),e.changeType=e.changeType.bind(e),e.GetstationList=e.GetstationList.bind(e),e.changePowerStationId=e.changePowerStationId.bind(e),e}return l(t,e),m(t,[{key:"componentDidMount",value:function(){this.getFaultLevelList(),this.GetstationList(),this.getFlawLevels()}},{key:"changePeople",value:function(e,t){var a=this;this.setState({currentPeople:e,processState:t},function(){a.getFaultLevelList()})}},{key:"changeType",value:function(e,t){var a=this;this.setState({currentType:e,faultLevel:t},function(){a.getFaultLevelList()})}},{key:"changePowerStationId",value:function(e){this.setState({stationName:e})}},{key:"getFlawLevels",value:function(){var e=this;(0,v.api)("s-solaromds/app/op/fault/levels",{},"GET").then(function(t){if(console.log("获取缺陷等级列表数据"),console.log(t),t&&t.length>0){var a=[];t.forEach(function(e,t){a.push({id:Number(e.levelId),name:e.levelName})}),console.log(a),e.setState({workTypes:[{id:-1,name:"缺陷等级"}].concat(a)})}})}},{key:"GetstationList",value:function(){var e=this;(0,v.api)("s-solaromds/app/station/stationListWithArea",{organizationId:localStorage.getItem("customerId")},"POST").then(function(t){console.log(t),e.setState({stationList:t.subData})})}},{key:"_renderItem",value:function(e,t,a){return p.default.createElement("div",{className:y.default.itemOutView},p.default.createElement("div",{className:y.default.workDetail,key:a,onClick:function(){goto("flawinfo?faultId="+e.faultId),localStorage.getItem("from")&&localStorage.removeItem("from")}},p.default.createElement("div",{className:y.default.workName},e.faultName?e.faultName:""),p.default.createElement("span",{className:"5"==e.processState?y.default.close+" "+y.default.finish:y.default.finish},"1"==e.processState?"新建":"2"==e.processState?"待分配":"3"==e.processState?"待处理":"4"==e.processState?"待关闭":"已关闭"),p.default.createElement("div",{className:y.default.workData},p.default.createElement("p",null,"缺陷编号:",p.default.createElement("span",null,e.serialNumber?e.serialNumber:"")),p.default.createElement("div",{className:y.default.context},p.default.createElement("div",{className:y.default.sName},"设备名称:"),p.default.createElement("span",null,e.deviceName?e.deviceName:"")),p.default.createElement("p",null,"缺陷等级:",p.default.createElement("span",{className:"1"===e.faultDimensions?y.default.serious:y.default.commonly},e.faultDimensionsValue?e.faultDimensionsValue:"")),p.default.createElement("p",null,"期望完成时间:",p.default.createElement("span",null,e.expectedTime?e.expectedTime:"")))))}},{key:"goBack",value:function(){k.nativeHistory.push("/menus")}},{key:"render",value:function(){var e=this,t=this.state,n=t.currentType,i=t.currentPeople,o=t.showSort,l=t.showSelect,r=t.faultLevelList,d=t.stationList,m=t.stationName,f=(t.showEmpty,t.workTypes),u=t.dataSource,_=t.refreshing,h=(t.currPage,t.totalPage),x=t.loading,b=t.page;return console.log(r),p.default.createElement("div",{className:y.default.container},p.default.createElement(g.default,{goBack:this.goBack,title:"缺陷",leftIcon:a(1350),iconRight:y.default.headerIconRight,rightClick:function(){goto("flawnew")}}),p.default.createElement("div",{className:y.default.workType},p.default.createElement("div",{className:y.default.siteNameView},p.default.createElement("span",{className:y.default.siteName,onClick:function(){localStorage.setItem("link","flaw"),goto("deviceList?link=flaw")}},(0,v.getQueryString)("siteName")?(0,v.getQueryString)("siteName"):localStorage.getItem("powerStationName")?localStorage.getItem("powerStationName"):d.length>0?d[m].name:""),p.default.createElement("span",{className:y.default.Bdown,onClick:function(){localStorage.setItem("link","flaw"),goto("deviceList?link=flaw")}})),p.default.createElement("div",{style:{height:"1px",width:"100vw",backgroundColor:"#D7DBE0",opacity:"0.4"}}),p.default.createElement(w.default,{currentPeople:i,currentType:n,showSelect:l,showSort:o,changePeople:this.changePeople,changeType:this.changeType,workTypes:f})),r.length>0?p.default.createElement("div",{className:y.default.faultLevelList},_&&p.default.createElement("div",{className:y.default.refreshLoading},p.default.createElement("i",null)),p.default.createElement(c.default,{style:{backgroundColor:"#FAFBFD"},dataSource:u,renderRow:this._renderItem.bind(this),useBodyScroll:!1,className:y.default.listView,renderFooter:function(){return p.default.createElement("div",{className:y.default.footerLoading},x&&p.default.createElement("i",null),p.default.createElement("span",{className:!x&&b>=h?y.default.nomoreData:""},!x&&b>=h?"没有更多数据了":"加载中..."))},pullToRefresh:p.default.createElement(s.default,{refreshing:_,onRefresh:function(){return e.getFaultLevelList("1")}}),onEndReached:function(){return e.getFaultLevelList("2")},pageSize:1})):p.default.createElement("div",{className:y.default.empty},p.default.createElement("div",null,p.default.createElement("div",{className:y.default.emptyImg}),p.default.createElement("div",{className:y.default.emptyText},"暂无数据"))))}}]),t}(f.Component);_.default.render(p.default.createElement(D,null),document.getElementById("container"))},1328:function(e,t,a){"use strict";a(137),a(142),a(1329)},1329:function(e,t,a){var n=a(1330);"string"==typeof n&&(n=[[e.id,n,""]]);a(13)(n,{});n.locals&&(e.exports=n.locals)},1330:function(e,t,a){t=e.exports=a(12)(),t.push([e.id,".am-pull-to-refresh-content{transform-origin:left top 0}.am-pull-to-refresh-content-wrapper{overflow:hidden}.am-pull-to-refresh-transition{transition:transform .3s}.am-pull-to-refresh-indicator{color:grey;text-align:center;height:25px}.am-pull-to-refresh-down .am-pull-to-refresh-indicator{margin-top:-25px}.am-pull-to-refresh-up .am-pull-to-refresh-indicator{margin-bottom:-25px}",""])},1331:function(e,t,a){"use strict";a(137),a(1332),a(1335)},1332:function(e,t,a){"use strict";a(137),a(1333)},1333:function(e,t,a){var n=a(1334);"string"==typeof n&&(n=[[e.id,n,""]]);a(13)(n,{});n.locals&&(e.exports=n.locals)},1334:function(e,t,a){t=e.exports=a(12)(),t.push([e.id,".am-list-header{padding:15px 15px 9px;font-size:14px;color:#888;width:100%;box-sizing:border-box}.am-list-footer{padding:9px 15px 15px;font-size:14px;color:#888}.am-list-body{position:relative;background-color:#fff;border-top:1px solid #ddd;border-bottom:1px solid #ddd}@media (-webkit-min-device-pixel-ratio:2),(min-resolution:2dppx){html:not([data-scale]) .am-list-body{border-top:none}html:not([data-scale]) .am-list-body:before{content:\"\";position:absolute;background-color:#ddd;display:block;z-index:1;top:0;right:auto;bottom:auto;left:0;width:100%;height:1px;transform-origin:50% 50%;transform:scaleY(.5)}}@media (-webkit-min-device-pixel-ratio:2) and (-webkit-min-device-pixel-ratio:3),(min-resolution:2dppx) and (min-resolution:3dppx){html:not([data-scale]) .am-list-body:before{transform:scaleY(.33)}}@media (-webkit-min-device-pixel-ratio:2),(min-resolution:2dppx){html:not([data-scale]) .am-list-body{border-bottom:none}html:not([data-scale]) .am-list-body:after{content:\"\";position:absolute;background-color:#ddd;display:block;z-index:1;top:auto;right:auto;bottom:0;left:0;width:100%;height:1px;transform-origin:50% 100%;transform:scaleY(.5)}}@media (-webkit-min-device-pixel-ratio:2) and (-webkit-min-device-pixel-ratio:3),(min-resolution:2dppx) and (min-resolution:3dppx){html:not([data-scale]) .am-list-body:after{transform:scaleY(.33)}}.am-list-body div:not(:last-child) .am-list-line{border-bottom:1px solid #ddd}@media (-webkit-min-device-pixel-ratio:2),(min-resolution:2dppx){html:not([data-scale]) .am-list-body div:not(:last-child) .am-list-line{border-bottom:none}html:not([data-scale]) .am-list-body div:not(:last-child) .am-list-line:after{content:\"\";position:absolute;background-color:#ddd;display:block;z-index:1;top:auto;right:auto;bottom:0;left:0;width:100%;height:1px;transform-origin:50% 100%;transform:scaleY(.5)}}@media (-webkit-min-device-pixel-ratio:2) and (-webkit-min-device-pixel-ratio:3),(min-resolution:2dppx) and (min-resolution:3dppx){html:not([data-scale]) .am-list-body div:not(:last-child) .am-list-line:after{transform:scaleY(.33)}}.am-list-item{position:relative;display:-ms-flexbox;display:flex;padding-left:15px;min-height:44px;background-color:#fff;vertical-align:middle;overflow:hidden;transition:background-color .2s;-ms-flex-align:center;align-items:center}.am-list-item .am-list-ripple{position:absolute;background:transparent;display:inline-block;overflow:hidden;will-change:box-shadow,transform;transition:box-shadow .2s cubic-bezier(.4,0,1,1),background-color .2s cubic-bezier(.4,0,.2,1),color .2s cubic-bezier(.4,0,.2,1);outline:none;cursor:pointer;border-radius:100%;transform:scale(0)}.am-list-item .am-list-ripple.am-list-ripple-animate{background-color:hsla(0,0%,62%,.2);animation:ripple 1s linear}.am-list-item.am-list-item-top .am-list-line{-ms-flex-align:start;align-items:flex-start}.am-list-item.am-list-item-top .am-list-line .am-list-arrow{margin-top:2px}.am-list-item.am-list-item-middle .am-list-line{-ms-flex-align:center;align-items:center}.am-list-item.am-list-item-bottom .am-list-line{-ms-flex-align:end;align-items:flex-end}.am-list-item.am-list-item-error .am-list-line .am-list-extra,.am-list-item.am-list-item-error .am-list-line .am-list-extra .am-list-brief{color:#f50}.am-list-item.am-list-item-active{background-color:#ddd}.am-list-item.am-list-item-disabled .am-list-line .am-list-content,.am-list-item.am-list-item-disabled .am-list-line .am-list-extra{color:#bbb}.am-list-item img{width:22px;height:22px;vertical-align:middle}.am-list-item .am-list-thumb:first-child{margin-right:15px}.am-list-item .am-list-thumb:last-child{margin-left:8px}.am-list-item .am-list-line{position:relative;display:-ms-flexbox;display:flex;-ms-flex:1;flex:1;-ms-flex-item-align:stretch;align-self:stretch;padding-right:15px;overflow:hidden}.am-list-item .am-list-line .am-list-content{-ms-flex:1;flex:1;color:#000;font-size:17px;text-align:left}.am-list-item .am-list-line .am-list-content,.am-list-item .am-list-line .am-list-extra{line-height:1.5;width:auto;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;padding-top:7px;padding-bottom:7px}.am-list-item .am-list-line .am-list-extra{-ms-flex-preferred-size:36%;flex-basis:36%;color:#888;font-size:16px;text-align:right}.am-list-item .am-list-line .am-list-brief,.am-list-item .am-list-line .am-list-title{width:auto;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.am-list-item .am-list-line .am-list-brief{color:#888;font-size:15px;line-height:1.5;margin-top:6px}.am-list-item .am-list-line .am-list-arrow{display:block;width:15px;height:15px;margin-left:8px;background-image:url(\"data:image/svg+xml;charset=utf-8,%3Csvg width='16' height='26' viewBox='0 0 16 26' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M2 0L0 2l11.5 11L0 24l2 2 14-13z' fill='%23C7C7CC' fill-rule='evenodd'/%3E%3C/svg%3E\");background-size:contain;background-repeat:no-repeat;background-position:50% 50%;visibility:hidden}.am-list-item .am-list-line .am-list-arrow-horizontal{visibility:visible}.am-list-item .am-list-line .am-list-arrow-vertical{visibility:visible;transform:rotate(90deg)}.am-list-item .am-list-line .am-list-arrow-vertical-up{visibility:visible;transform:rotate(270deg)}.am-list-item .am-list-line-multiple{padding:12.5px 15px 12.5px 0}.am-list-item .am-list-line-multiple .am-list-content,.am-list-item .am-list-line-multiple .am-list-extra{padding-top:0;padding-bottom:0}.am-list-item .am-list-line-wrap .am-list-content,.am-list-item .am-list-line-wrap .am-list-extra{white-space:normal}.am-list-item select{position:relative;display:block;width:100%;height:100%;padding:0;border:0;font-size:17px;-webkit-appearance:none;-moz-appearance:none;appearance:none;background-color:transparent}@keyframes ripple{to{opacity:0;transform:scale(2.5)}}",""])},1335:function(e,t,a){var n=a(1336);"string"==typeof n&&(n=[[e.id,n,""]]);a(13)(n,{});n.locals&&(e.exports=n.locals)},1336:function(e,t,a){t=e.exports=a(12)(),t.push([e.id,".am-indexed-list-section-body.am-list-body,.am-indexed-list-section-body.am-list-body .am-list-item:last-child .am-list-line{border-bottom:0}.am-indexed-list-section-body.am-list-body .am-list-item:last-child .am-list-line:after,.am-indexed-list-section-body.am-list-body:after{display:none!important}.am-indexed-list-section-header.am-list-body,.am-indexed-list-section-header.am-list-body .am-list-item .am-list-line{border-bottom:0}.am-indexed-list-section-header.am-list-body .am-list-item .am-list-line:after,.am-indexed-list-section-header.am-list-body:after{display:none!important}.am-indexed-list-section-header .am-list-item{height:30px;min-height:30px;background-color:#f5f5f9}.am-indexed-list-section-header .am-list-item .am-list-line{height:30px;min-height:30px}.am-indexed-list-section-header .am-list-item .am-list-content{font-size:14px!important;color:#888!important}.am-indexed-list-quick-search-bar{position:fixed;top:0;right:0;z-index:0;text-align:center;color:#108ee9;font-size:16px;list-style:none;padding:0}.am-indexed-list-quick-search-bar li{padding:0 5px}.am-indexed-list-quick-search-bar-over{background-color:rgba(0,0,0,.4)}.am-indexed-list-qsindicator{position:absolute;left:50%;top:50%;margin:-15px auto auto -30px;width:60px;height:30px;background:transparent;opacity:.7;color:#0af;font-size:20px;border-radius:30px;z-index:1999;text-align:center;line-height:30px}.am-indexed-list-qsindicator-hide{display:none}",""])},1337:function(e,t,a){"use strict";function n(e){return e&&e.__esModule?e:{default:e}}function i(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}function o(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}function l(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}Object.defineProperty(t,"__esModule",{value:!0});var r=function(){function e(e,t){for(var a=0;a<t.length;a++){var n=t[a];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}return function(t,a,n){return a&&e(t.prototype,a),n&&e(t,n),t}}(),s=a(2),d=n(s),c=a(1338),m=n(c),f=[{id:0,name:"状态"},{id:1,name:"新建"},{id:2,name:"待分配"},{id:3,name:"待处理"},{id:4,name:"待关闭"},{id:5,name:"已关闭"}],p=function(e){function t(e){i(this,t);var a=o(this,(t.__proto__||Object.getPrototypeOf(t)).call(this,e));return a.state={showChange:!1,showChangeType:!1,workPeople:f[e.currentPeople].name,workType:"缺陷等级",workTypes:[{id:-1,name:"缺陷等级"},{id:0,name:"一般"},{id:1,name:"严重"}]},a}return l(t,e),r(t,[{key:"componentWillReceiveProps",value:function(e){e.workTypes&&e.workTypes.length>0&&this.setState({workTypes:e.workTypes}),this.setState({workPeople:f[e.currentPeople].name,workType:this.state.workTypes[e.currentType].name})}},{key:"render",value:function(){var e=this,t=this.state,a=t.showChange,n=t.showChangeType,i=t.workPeople,o=t.workType,l=t.workTypes,r=this.props,s=r.changePeople,c=r.changeType,p=r.currentPeople,u=r.currentType;return d.default.createElement("div",{className:m.default.container},d.default.createElement("div",{className:m.default.body},0==p?d.default.createElement("div",{className:a?m.default.activeBlack:m.default.normalBlack,onClick:function(){e.setState({showChange:!a,showChangeType:!1})}},d.default.createElement("span",null,i),d.default.createElement("span",null)):d.default.createElement("div",{className:a?m.default.activeBlue:m.default.normalBlue,onClick:function(){e.setState({showChange:!a,showChangeType:!1})}},d.default.createElement("span",null,i),d.default.createElement("span",null)),d.default.createElement("span",{className:m.default.line}),0==u?d.default.createElement("div",{className:n?m.default.activeBlack:m.default.normalBlack,onClick:function(){e.setState({showChangeType:!n,showChange:!1})}},d.default.createElement("span",null,o),d.default.createElement("span",null)):d.default.createElement("div",{className:n?m.default.activeBlue:m.default.normalBlue,onClick:function(){e.setState({showChangeType:!n,showChange:!1})}},d.default.createElement("span",null,o),d.default.createElement("span",null))),n?d.default.createElement("div",{className:m.default.showWorkType,onClick:function(){e.setState({showChangeType:!1})}},d.default.createElement("div",{style:{background:"#fff"}},l.map(function(t,a){return d.default.createElement("div",{key:a,onClick:function(){e.setState({showChangeType:!1}),c(a,t.id)},className:u==a?m.default.workTypeListActive:m.default.workTypeListNormal},d.default.createElement("span",null,t.id===-1?"所有等级":t.name))}))):null,a?d.default.createElement("div",{className:m.default.showWorkPeople,onClick:function(){e.setState({showChange:!1})}},d.default.createElement("div",{style:{background:"#fff"}},f.map(function(t,a){return d.default.createElement("div",{key:a,onClick:function(){e.setState({showChange:!1}),s(a,t.id)},className:p==a?m.default.workPeopleListActive:m.default.workPeopleListNormal},d.default.createElement("span",null,0==t.id?"所有状态":t.name))}))):null)}}]),t}(s.Component);t.default=p},1338:function(e,t,a){var n=a(1339);"string"==typeof n&&(n=[[e.id,n,""]]);a(13)(n,{});n.locals&&(e.exports=n.locals)},1339:function(e,t,a){t=e.exports=a(12)(),t.push([e.id,".flaw-components-ChangeData-_index_container_1m70S{width:100%;font-size:14px;position:relative;font-weight:500}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD-{display:-ms-flexbox;display:flex;-ms-flex-direction:row;flex-direction:row;-ms-flex-pack:justify;justify-content:space-between;-ms-flex-align:center;align-items:center;z-index:10000;box-shadow:0 5px 7px 0 #edeff1;position:absolute;width:100%;height:44px;overflow:hidden;background:#fff}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- .flaw-components-ChangeData-_index_line_3en7X{width:1px;height:14px;background:#d8d9e6;display:inline-block;z-index:101}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- div{text-align:center;font-size:14px;font-weight:500;width:50%}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- .flaw-components-ChangeData-_index_normalBlack_2unCV span:first-child{color:#000}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- .flaw-components-ChangeData-_index_normalBlack_2unCV span:nth-child(2){display:inline-block;width:11px;height:8px;margin-left:7px;background:url("+a(1340)+") no-repeat 50%}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- .flaw-components-ChangeData-_index_activeBlack_3ZOFW span:first-child{color:#000}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- .flaw-components-ChangeData-_index_activeBlack_3ZOFW span:nth-child(2){display:inline-block;width:11px;height:8px;margin-left:7px;background:url("+a(1341)+") no-repeat 50%}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- .flaw-components-ChangeData-_index_normalBlue_1GZWL span:first-child{color:#0084ff}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- .flaw-components-ChangeData-_index_normalBlue_1GZWL span:nth-child(2){display:inline-block;width:11px;height:8px;margin-left:7px;background:url("+a(1342)+") no-repeat 50%}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- .flaw-components-ChangeData-_index_activeBlue_1A7GK span:first-child{color:#0084ff}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_body_2WXD- .flaw-components-ChangeData-_index_activeBlue_1A7GK span:nth-child(2){display:inline-block;width:11px;height:8px;margin-left:7px;background:url("+a(1343)+") no-repeat 50%}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_showWorkPeople_1wYSS{position:absolute;top:44px;width:100%;height:100vh;background:rgba(0,0,0,.3);color:#3e3e47;font-size:14px;z-index:99}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_showWorkPeople_1wYSS .flaw-components-ChangeData-_index_workPeopleListNormal_19yvI{height:44px;line-height:44px;font-weight:500;margin-left:30px;color:#3e3e47}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_showWorkPeople_1wYSS .flaw-components-ChangeData-_index_workPeopleListActive_3swDu{height:44px;line-height:44px;font-weight:500;margin-left:30px;color:#0084ff}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_showWorkType_3r-t0{position:absolute;top:44px;width:100%;height:100vh;background:rgba(0,0,0,.3);color:#3e3e47;font-size:14px;z-index:99}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_showWorkType_3r-t0 .flaw-components-ChangeData-_index_workTypeListNormal_2-hXC{height:44px;line-height:44px;font-weight:500;margin-left:30px;color:#3e3e47}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_showWorkType_3r-t0 .flaw-components-ChangeData-_index_workTypeListActive_aeZgG{height:44px;line-height:44px;font-weight:500;margin-left:30px;color:#0084ff}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_normal_17U4f{color:#3e3e47}.flaw-components-ChangeData-_index_container_1m70S .flaw-components-ChangeData-_index_active_2RgIz{color:#0084ff}",""]),t.locals={container:"flaw-components-ChangeData-_index_container_1m70S",body:"flaw-components-ChangeData-_index_body_2WXD-",line:"flaw-components-ChangeData-_index_line_3en7X",normalBlack:"flaw-components-ChangeData-_index_normalBlack_2unCV",activeBlack:"flaw-components-ChangeData-_index_activeBlack_3ZOFW",normalBlue:"flaw-components-ChangeData-_index_normalBlue_1GZWL",activeBlue:"flaw-components-ChangeData-_index_activeBlue_1A7GK",showWorkPeople:"flaw-components-ChangeData-_index_showWorkPeople_1wYSS",workPeopleListNormal:"flaw-components-ChangeData-_index_workPeopleListNormal_19yvI",workPeopleListActive:"flaw-components-ChangeData-_index_workPeopleListActive_3swDu",showWorkType:"flaw-components-ChangeData-_index_showWorkType_3r-t0",workTypeListNormal:"flaw-components-ChangeData-_index_workTypeListNormal_2-hXC",workTypeListActive:"flaw-components-ChangeData-_index_workTypeListActive_aeZgG",normal:"flaw-components-ChangeData-_index_normal_17U4f",active:"flaw-components-ChangeData-_index_active_2RgIz"}},1340:function(e,t,a){e.exports=a.p+"assets/fonts/down_black.svg"},1341:function(e,t,a){e.exports=a.p+"assets/fonts/up_black.svg"},1342:function(e,t,a){e.exports=a.p+"assets/fonts/down_blue.svg"},1343:function(e,t,a){e.exports=a.p+"assets/fonts/up_blue.svg"},1344:function(e,t,a){var n=a(1345);"string"==typeof n&&(n=[[e.id,n,""]]);a(13)(n,{});n.locals&&(e.exports=n.locals)},1345:function(e,t,a){t=e.exports=a(12)(),t.push([e.id,".flaw-_index_container_3oqEP{width:100%;margin:0;height:100%;background:#fafbfd;overflow:hidden}.flaw-_index_container_3oqEP,.flaw-_index_workType_K-EY-{display:-ms-flexbox;display:flex;-ms-flex-direction:column;flex-direction:column}.flaw-_index_workType_K-EY-{margin-top:64px;height:90px;background-color:#fff;position:relative}.flaw-_index_siteNameView_1-URe{height:45px;line-height:45px;width:100%;overflow:hidden;-ms-flex-direction:row;flex-direction:row;display:-ms-flexbox;display:flex;-ms-flex-align:center;align-items:center;-ms-flex-pack:justify;justify-content:space-between}.flaw-_index_Bdown_2WBgx{width:18px;height:18px;display:inline-block;margin-right:16px;background:url("+a(1346)+") no-repeat 50%}.flaw-_index_siteName_17TmF{display:inline-block;vertical-align:center;padding:0 2px 0 20px;color:#101015;font-size:18px;font-weight:500;width:calc(100vw - 36px);overflow:hidden;white-space:nowrap;text-overflow:ellipsis}.flaw-_index_listView_1i6ES{width:100%;height:100%!important;-ms-flex:1;flex:1;background-color:#fafbfd;border:none}.flaw-_index_faultLevelList_14-5m{-ms-flex:1;flex:1;width:100%;overflow:auto;background:#fafbfd}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy{padding:15px 16px 10px 18px;position:relative;background:#fff;box-shadow:0 6px 20px 2px rgba(47,52,186,.06);border-radius:4px}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_workName_9YIaL{font-size:17px;font-weight:700;color:#212029;margin-bottom:11px;max-width:75%;line-height:24px;word-break:break-all;word-wrap:break-word;text-overflow:ellipsis;display:-webkit-box}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_finish_2AwsI{display:inline-block;width:60px;height:22px;font-size:12px;line-height:22px;text-align:center;position:absolute;top:15px;right:16px;background:rgba(255,142,20,.1);border-radius:15px;color:#ff8e14;font-weight:500}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_close_20IYD{color:#8a8b99;background:rgba(215,216,224,.4);font-weight:500}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_workData_FShIp p{color:#8a8b99;font-size:14px;margin:8px 0}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_workData_FShIp .flaw-_index_serious_36tKF{color:#f23349;font-weight:500}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_workData_FShIp .flaw-_index_commonly_116vp{color:#ff8e14;font-weight:500}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_workData_FShIp span{color:#101015;font-size:14px;margin:8px 10px;-ms-flex:1;flex:1}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_context_3HUTg{display:-ms-flexbox;display:flex;-ms-flex-direction:row;flex-direction:row;-ms-flex-align:start;align-items:flex-start}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_context_3HUTg span{margin-top:0;margin-bottom:0}.flaw-_index_faultLevelList_14-5m .flaw-_index_workDetail_2q0hy .flaw-_index_sName_3MwNm{color:#8a8b99;font-size:14px;margin:0}.flaw-_index_empty_1VLGp{width:60px;height:79px;margin:35% auto}.flaw-_index_empty_1VLGp .flaw-_index_emptyImg_24cYR{width:60px;height:60px;background:url("+a(1347)+") no-repeat 50%;margin-bottom:2px}.flaw-_index_empty_1VLGp .flaw-_index_emptyText_2RuAC{font-size:12px;font-weight:400;color:#a4a5b3;text-align:center}.flaw-_index_headerIconRight_1wry4{background-image:url("+a(1348)+");height:20px;background-repeat:no-repeat}.flaw-_index_container_3oqEP .am-pull-to-refresh-indicator{display:none!important;color:transparent!important}.flaw-_index_container_3oqEP .am-pull-to-refresh-indicator>svg>use{display:none!important}.flaw-_index_container_3oqEP .am-pull-to-refresh-indicator>svg{height:26.666px;height:1.66667rem;width:26.666px;width:1.66667rem;background:url("+a(1349)+") no-repeat;background-size:1.66667rem 1.66667rem}.flaw-_index_container_3oqEP .am-icon-loading{animation-duration:2s!important}.flaw-_index_container_3oqEP .am-list-footer{padding:0!important;background:#fafbfd!important}.flaw-_index_container_3oqEP .am-list-body{background-color:transparent}.flaw-_index_container_3oqEP .am-list-body:after,.flaw-_index_container_3oqEP .am-list-body:before{display:none!important}.flaw-_index_container_3oqEP .am-pull-to-refresh-content-wrapper{overflow:visible}.flaw-_index_footerLoading_3Wy9r{display:-ms-flexbox;display:flex;-ms-flex-pack:center;justify-content:center;-ms-flex-align:center;align-items:center;margin-top:15px}.flaw-_index_footerLoading_3Wy9r>i{background:url("+a(1349)+") no-repeat;height:26.666px;height:1.66667rem;width:26.666px;width:1.66667rem;background-size:100% 100%;background-position:50%;animation:flaw-_index_Spin_1g7vD 2s linear infinite}@keyframes flaw-_index_Spin_1g7vD{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}.flaw-_index_footerLoading_3Wy9r>span{margin-left:10.666px;margin-left:.66667rem;padding:16px 0;padding:1rem 0;font-size:12px;font-family:PingFangSC-Regular,PingFang SC;font-weight:400;color:#8a8b99;line-height:26.666px;line-height:1.66667rem}.flaw-_index_nomoreData_E9siQ{padding:0 0 16px!important;padding:0 0 1rem!important;margin-left:0!important}.flaw-_index_itemOutView_3RNVF{width:100vw;height:auto;background:#fafbfd;padding:16px 16px 0}.flaw-_index_refreshLoading_VndjF{display:-ms-flexbox;display:flex;-ms-flex-pack:center;justify-content:center}.flaw-_index_refreshLoading_VndjF>i{display:block;margin-top:18.666px;margin-top:1.16667rem;background:url("+a(1349)+") no-repeat;height:26.666px;height:1.66667rem;width:26.666px;width:1.66667rem;background-size:100% 100%;background-position:50%;animation:flaw-_index_Spin_1g7vD 2s linear infinite}",""]),t.locals={container:"flaw-_index_container_3oqEP",workType:"flaw-_index_workType_K-EY-",siteNameView:"flaw-_index_siteNameView_1-URe",Bdown:"flaw-_index_Bdown_2WBgx",siteName:"flaw-_index_siteName_17TmF",listView:"flaw-_index_listView_1i6ES",faultLevelList:"flaw-_index_faultLevelList_14-5m",workDetail:"flaw-_index_workDetail_2q0hy",workName:"flaw-_index_workName_9YIaL",finish:"flaw-_index_finish_2AwsI",close:"flaw-_index_close_20IYD",workData:"flaw-_index_workData_FShIp",serious:"flaw-_index_serious_36tKF",commonly:"flaw-_index_commonly_116vp",
context:"flaw-_index_context_3HUTg",sName:"flaw-_index_sName_3MwNm",empty:"flaw-_index_empty_1VLGp",emptyImg:"flaw-_index_emptyImg_24cYR",emptyText:"flaw-_index_emptyText_2RuAC",headerIconRight:"flaw-_index_headerIconRight_1wry4",footerLoading:"flaw-_index_footerLoading_3Wy9r",Spin:"flaw-_index_Spin_1g7vD",nomoreData:"flaw-_index_nomoreData_E9siQ",itemOutView:"flaw-_index_itemOutView_3RNVF",refreshLoading:"flaw-_index_refreshLoading_VndjF"}},1346:function(e,t,a){e.exports=a.p+"assets/fonts/Bright.svg"},1347:function(e,t,a){e.exports=a.p+"assets/fonts/empty.svg"},1348:function(e,t,a){e.exports=a.p+"assets/fonts/plus.svg"},1349:function(e,t,a){e.exports=a.p+"assets/imgs/loading_2J-AJ.png"},1350:function(e,t,a){e.exports=a.p+"assets/fonts/menu.svg"}});