webpackJsonp([7],{0:function(e,t,l){e.exports=l(1351)},1351:function(e,t,l){"use strict";function a(e){return e&&e.__esModule?e:{default:e}}function n(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}function o(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}function i(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}var s=function(){function e(e,t){for(var l=0;l<t.length;l++){var a=t[l];a.enumerable=a.enumerable||!1,a.configurable=!0,"value"in a&&(a.writable=!0),Object.defineProperty(e,a.key,a)}}return function(t,l,a){return l&&e(t.prototype,l),a&&e(t,a),t}}(),d=l(2),c=a(d),r=l(5),u=a(r);l(15);var f=l(9),p=a(f),m=l(1352),h=a(m),g=l(24),x=l(1356),v=a(x),_=function(e){function t(e){n(this,t);var l=o(this,(t.__proto__||Object.getPrototypeOf(t)).call(this,e));return l.state={recordId:(0,g.getQueryString)("recordId"),imageList:[],showPreView:!1,videoInfo:[],resultInfo:{},preViewIndex:0,showImageList:[]},l}return i(t,e),s(t,[{key:"componentDidMount",value:function(){var e=this;(0,g.api)("s-solaromds/app/op/fault/getHandleResult/"+this.state.recordId,{},"GET").then(function(t){if(console.log(t),t){var l=[];t.images&&t.images.map(function(e){l.push({fileUrl:e})});var a=[];t.vedios&&t.vedios.length>0&&t.vedios.map(function(e){a.push({fileUrl:e})}),e.setState({imageList:l,videoInfo:a,resultInfo:t||{}})}}).catch(function(e){console.log(e)})}},{key:"handleClosePreview",value:function(){this.setState({showPreView:!1,showImageList:[],preViewIndex:0})}},{key:"handlePreview",value:function(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:[];console.log(e);for(var l=[],a=0;a<t.length;a++)l.push({fileUrl:"https://solarasset.blob.core.chinacloudapi.cn/omtest1/"+t[a].fileUrl});this.setState({preViewIndex:e,showPreView:!0,showImageList:l})}},{key:"play",value:function(e){console.log("开始播放");var t=document.getElementById("myVideo_"+e);t.play();try{t.requestFullscreen()}catch(e){console.log(e)}try{t.webkitRequestFullScreen()}catch(e){console.log(e)}}},{key:"render",value:function(){var e=this,t=this.state,a=t.imageList,n=t.showPreView,o=t.preViewIndex,i=t.resultInfo,s=t.videoInfo,d=t.showImageList,r={paddingTop:n?"0px":"64px",paddingBottom:n?"0px":"20px"};return c.default.createElement("div",{className:h.default.viewResult,style:r},c.default.createElement(p.default,{headStyle:n?h.default.headStyle:h.default.headStyle2,leftStyle:h.default.leftStyle,leftIcon:l(1363),title:"处理结果"}),c.default.createElement("div",{className:h.default.content},c.default.createElement("div",{className:h.default.boxDiv},c.default.createElement("span",{className:h.default.title},"处理方式"),c.default.createElement("span",{className:h.default.desc},i.handleDescribe||"-")),c.default.createElement("div",{className:h.default.boxDiv},c.default.createElement("span",{className:h.default.title},"处理结果"),c.default.createElement("span",{className:h.default.desc},i.handleResult||"-")),a&&a.length>0?c.default.createElement("div",{className:h.default.boxDivPhoto},c.default.createElement("span",{className:h.default.title},"照片"),c.default.createElement("div",{className:h.default.imgs},a.map(function(t,l){return c.default.createElement("img",{key:l,className:h.default.singlePhoto,style:{marginRight:"12px"},src:"https://solarasset.blob.core.chinacloudapi.cn/omtest1/"+t.fileUrl,onClick:function(){e.handlePreview(l,a)}})}))):null,s&&s.length>0?c.default.createElement("div",{className:h.default.boxDivPhoto},c.default.createElement("span",{className:h.default.title},"视频"),c.default.createElement("div",{className:h.default.imgs},s.map(function(t,l){return c.default.createElement("div",{key:l,onClick:function(){e.play(l)},style:{position:"relative"}},c.default.createElement("video",{className:h.default.singlePhoto,style:{marginRight:"12px"},id:"myVideo_"+l},c.default.createElement("source",{src:"https://solarasset.blob.core.chinacloudapi.cn/omtest1/"+t.fileUrl,type:"video/mp4"}),c.default.createElement("source",{src:"https://solarasset.blob.core.chinacloudapi.cn/omtest1/"+t.fileUrl,type:"video/ogg"}),c.default.createElement("source",{src:"https://solarasset.blob.core.chinacloudapi.cn/omtest1/"+t.fileUrl,type:"video/quicktime"}),"您的浏览器不支持该视频格式。"),c.default.createElement("i",{className:h.default.play}))}))):null,c.default.createElement("div",{className:h.default.boxDiv},c.default.createElement("span",{className:h.default.title},"处理日期"),c.default.createElement("span",{className:h.default.desc},i.resolveTime||"-")),c.default.createElement("div",{className:h.default.boxDiv},c.default.createElement("span",{className:h.default.title},"处理人"),c.default.createElement("span",{className:h.default.desc},i.resolveName||"-")),c.default.createElement("div",{className:h.default.boxDiv},c.default.createElement("span",{className:h.default.title},"操作票号"),c.default.createElement("span",{className:h.default.desc},i.actionTicketId||"-")),i.actionPhoto?c.default.createElement("div",{className:h.default.boxDivPhoto},c.default.createElement("span",{className:h.default.title},"操作票照片"),c.default.createElement("img",{className:h.default.singlePhoto,src:"https://solarasset.blob.core.chinacloudapi.cn/omtest1/"+i.actionPhoto,onClick:function(){e.handlePreview(0,[{fileUrl:i.actionPhoto}])}})):null,c.default.createElement("div",{className:h.default.boxDiv},c.default.createElement("span",{className:h.default.title},"工作票号"),c.default.createElement("span",{className:h.default.desc},i.workTicketId||"-")),i.workPhoto?c.default.createElement("div",{className:h.default.boxDivPhoto},c.default.createElement("span",{className:h.default.title},"工作票照片"),c.default.createElement("img",{className:h.default.singlePhoto,src:"https://solarasset.blob.core.chinacloudapi.cn/omtest1/"+i.workPhoto,onClick:function(){e.handlePreview(0,[{fileUrl:i.workPhoto}])}})):null,c.default.createElement("div",{style:{height:"40px",width:"100vw",backgroundColor:"white"}}),n&&c.default.createElement(v.default,{imageList:d,activeIndex:o,close:function(){e.handleClosePreview()}})))}}]),t}(d.Component);u.default.render(c.default.createElement(_,null),document.getElementById("container"))},1352:function(e,t,l){var a=l(1353);"string"==typeof a&&(a=[[e.id,a,""]]);l(13)(a,{});a.locals&&(e.exports=a.locals)},1353:function(e,t,l){t=e.exports=l(12)(),t.push([e.id,".flawHandleResult-_index_viewResult_25_d4{width:100vw;height:100vh;padding-top:64px;box-sizing:border-box;background:#fff;position:relative;padding-bottom:20px;font-family:PingFangSC-Regular,PingFang SC}.flawHandleResult-_index_headStyle_34p5z{display:none}.flawHandleResult-_index_headStyle2_1aNRj{border-bottom:1px solid rgba(215,219,224,.4)}.flawHandleResult-_index_content_luwma{position:relative;height:100%;width:100%;overflow:auto}.flawHandleResult-_index_leftStyle_n9s0Q{width:14px;height:14px;margin-top:3px}.flawHandleResult-_index_boxDiv_2xD54{background-color:#fff;width:100vw;padding:20px 16px 0;color:#8a8b99;font-size:14px}.flawHandleResult-_index_title_1oLB2{display:inline-block;font-family:PingFangSC-Regular,PingFang SC}.flawHandleResult-_index_desc_3gjKH{color:#101015;margin-top:10px;display:block;font-family:PingFangSC-Regular,PingFang SC;line-height:20px;word-wrap:break-word}.flawHandleResult-_index_boxDivPhoto_3NSFc{background-color:#fff;width:100vw;padding:20px 16px 0;color:#8a8b99;font-size:14px;display:-ms-flexbox;display:flex;-ms-flex-direction:column;flex-direction:column}.flawHandleResult-_index_singlePhoto_jCNdW{height:60px;width:60px;-o-object-fit:cover;object-fit:cover;background:url("+l(1354)+") no-repeat;background-position:50%;background-size:cover;border:1px solid #c2ccd6;border-radius:4px;margin-top:10px}.flawHandleResult-_index_imgs_X3idq{display:-ms-flexbox;display:flex;-ms-flex-direction:row;flex-direction:row}.flawHandleResult-_index_play_3Nu4g{position:absolute;right:27px;top:26px;height:28px;width:28px;background:url("+l(1355)+") no-repeat;background-size:cover;background-position:50%}",""]),t.locals={viewResult:"flawHandleResult-_index_viewResult_25_d4",headStyle:"flawHandleResult-_index_headStyle_34p5z",headStyle2:"flawHandleResult-_index_headStyle2_1aNRj",content:"flawHandleResult-_index_content_luwma",leftStyle:"flawHandleResult-_index_leftStyle_n9s0Q",boxDiv:"flawHandleResult-_index_boxDiv_2xD54",title:"flawHandleResult-_index_title_1oLB2",desc:"flawHandleResult-_index_desc_3gjKH",boxDivPhoto:"flawHandleResult-_index_boxDivPhoto_3NSFc",singlePhoto:"flawHandleResult-_index_singlePhoto_jCNdW",imgs:"flawHandleResult-_index_imgs_X3idq",play:"flawHandleResult-_index_play_3Nu4g"}},1354:function(e,t,l){e.exports=l.p+"assets/imgs/video_3WDZl.png"},1355:function(e,t,l){e.exports=l.p+"assets/fonts/play.svg"},1363:function(e,t,l){e.exports=l.p+"assets/fonts/close.svg"}});