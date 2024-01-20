import { Canvas } from 'canvas-constructor/browser'
import JoiningImage from '~/assets/joining.png'

export default async function generateJoiningImage(_joiningPosition?: number) {
  const canvasElement = document.createElement('canvas')
  canvasElement.width = 820
  canvasElement.height = 312

  const imageElement = document.createElement('img')
  imageElement.src = JoiningImage

  return await new Canvas(canvasElement)
    .printImage(imageElement, 0, 0)
    .setColor('#ffffff')
    .setTextFont('bold 48px Inter')
    .printText('Member', 25, 280)
    .toBlobAsync()
}
