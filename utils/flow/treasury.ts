import * as fcl from '@onflow/fcl'
import TREASURY_INFO from '~/cadence/scripts/getSarpanchCommunityTreasuryInfo.cdc?raw'

export default async function getTreasuryInfo(): Promise<TreasuryData> {
  const { NC_ADDRESS } = useRuntimeConfig().public

  const info = await fcl.query({
    cadence: TREASURY_INFO,
    // @ts-expect-error something wrong with fcl typings
    args: (arg, t) => [arg(NC_ADDRESS, t.Address)],
  })

  consola.withTag('[TREASURY]').info('Info', info)
  return info
}
