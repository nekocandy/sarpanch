import '../config'
import * as fcl from '@onflow/fcl'
import type { CurrentUser } from '@onflow/typedefs'
import { userData } from '../store'
import { network } from '.'

fcl.currentUser.subscribe((user: CurrentUser) => {
  userData.value = user
})

export const logIn = () => fcl.logIn(network)
export const logOut = () => fcl.unauthenticate()
