const path = require('path')
const sharp = require('sharp')

// マップから岩手県の地図だけを切り取って、サイズ調整して
// ogp元画像の所定の位置に貼り付けて ogp.png として書き出す
sharp(path.join(__dirname, '../ogp/weekly-map.png'))
  .extract({
    left: 657,
    top: 67,
    width: 600,
    height: 925,
  })
  .resize(340)
  .toBuffer({ resolveWithObject: true })
  .then(({ data, _info }) => {
    sharp(path.join(__dirname, '../static/ogp-original.png'))
      .composite([{ input: data, top: 55, left: 140 }])
      .png({ compressionLevel: 9, palette: true })
      .toFile(path.join(__dirname, '../static/ogp.png'))
  })
