// rem 算法 , 不需要添加入口函数，先让JS计算出来，在基于计算后的font-size去渲染css
// 获取根目录
var oHtml = document.documentElement;
function getSize() {
  // 获取屏幕的大小
  var screenWidth = oHtml.offsetWidth;
  if (screenWidth >= 640) {
    oHtml.style.fontSize = '27.30667px';
  } else if (screenWidth <= 320) {
    oHtml.style.fontSize = '13.65333px';
  } else {
    // 动态去计算这个屏幕下的font-size值
    oHtml.style.fontSize = screenWidth / (375 / 16) + 'px';
  }
}
// 最开始先调用一次
getSize();
// 当缩放的时候自动去计算
window.addEventListener('resize', getSize);