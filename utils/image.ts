import { Canvas } from 'canvas-constructor/browser'
import type { File } from 'nft.storage'
import { NFTStorage } from 'nft.storage'
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

const { STORAGE_TOKEN } = useRuntimeConfig().public
export const imageClient = new NFTStorage({ token: STORAGE_TOKEN })

export async function uploadImage(file: File) {
  return await imageClient.storeBlob(file)
}
