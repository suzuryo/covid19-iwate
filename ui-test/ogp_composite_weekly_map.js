const path = require('path')
const sharp = require('sharp')

// 合成する元画像ファイル
const ogp = sharp(path.join(__dirname, '../static/ogp-original.png'))

// 岩手県の感染状況を表現するマップ
const weeklyMap = sharp(path.join(__dirname, '../ogp/weekly-map.png'))

// マップから岩手県の地図だけを切り取って、サイズ調整して
// ogp元画像の所定の位置に貼り付けて ogp.png として書き出す
weeklyMap
  .extract({
    left: 657,
    top: 67,
    width: 600,
    height: 925,
  })
  .resize(340)
  .toBuffer({ resolveWithObject: true })
  .then(({ data, _info }) => {
    ogp
      .composite([{ input: data, top: 55, left: 140 }])
      .png({ compressionLevel: 9, palette: true })
      .toFile(path.join(__dirname, '../static/ogp.png'))
  })
