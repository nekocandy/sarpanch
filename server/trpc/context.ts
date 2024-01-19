import type { inferAsyncReturnType } from '@trpc/server'
import type { H3Event } from 'h3'

// import { getServerSession } from '#auth'

export async function createContext(_event: H3Event) {
  // const session = await getServerSession(_event)

  return {
    // user: session,
  }
}

export type Context = inferAsyncReturnType<typeof createContext>
