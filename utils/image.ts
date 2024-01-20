import { Canvas } from 'canvas-constructor/browser'
import JoiningImage from '~/assets/joining.png'

export default function generateJoiningImage(joiningPosition: number) {
  const canvasElement = document.createElement('canvas')
  canvasElement.width = 820
  canvasElement.height = 312

  const imageElement = document.createElement('img')
  imageElement.src = JoiningImage

  return new Canvas(canvasElement)
    .printImage(imageElement, 0, 0)
    .setColor('#ffffff')
    .setTextFont('bold 48px Inter')
    .printText(joiningPosition.toString(), 25, 280)
    .toDataURL()
}
