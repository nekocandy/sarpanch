/* eslint-disable node/prefer-global/buffer */
import * as fcl from '@onflow/fcl'
import { SHA3 } from 'sha3'
import EC from 'elliptic'
import flow from '~/flow.json'

import '~/utils/flow/index'

// eslint-disable-next-line new-cap
const ec = new EC.ec('p256')

// @ts-expect-error default exists
const CONTRACT_ADDRESS = flow.accounts.default as { address: string, key: string }

export function signMessage(message: string) {
  const key = ec.keyFromPrivate(Buffer.from(CONTRACT_ADDRESS.key, 'hex'))
  const sig = key.sign(hashMessage(message)) // hashMsgHex -> hash
  const n = 32
  const r = sig.r.toArrayLike(Buffer, 'be', n)
  const s = sig.s.toArrayLike(Buffer, 'be', n)
  return Buffer.concat([r, s]).toString('hex')
}

export function hashMessage(message: string) {
  const sha = new SHA3(256)
  sha.update(Buffer.from(message, 'hex'))
  return sha.digest()
}

export async function signFromServer(account: any) {
  const addr = CONTRACT_ADDRESS.address
  const keyId = 0

  return {
    ...account,
    tempId: `${addr}-${keyId}`,
    addr: fcl.sansPrefix(addr),
    keyId: Number(keyId),
    signingFunction: async (signable: any) => {
      return {
        addr: fcl.withPrefix(addr),
        keyId: Number(keyId),
        signature: signMessage(signable.message),
      }
    },
  }
}
