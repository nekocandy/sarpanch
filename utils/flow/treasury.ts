import * as fcl from '@onflow/fcl'
import TREASURY_INFO from '~/cadence/scripts/getSarpanchCommunityTreasuryInfo.cdc?raw'
import flowData from '~/flow.json'

export default async function getTreasuryInfo(): Promise<TreasuryData> {
//   const { NC_ADDRESS } = useRuntimeConfig().public

  const info = await fcl.query({
    cadence: TREASURY_INFO,
    // TODO: change this to use the actual address
    // @ts-expect-error no idea
    args: (arg, t) => [arg(`0x${flowData.accounts.default.address}`, t.Address)],
  })

  consola.withTag('[TREASURY]').info('Info', info)
  return info
}
