import { TRPCError, initTRPC } from '@trpc/server'
import type { Context } from '~/server/trpc/context'

const t = initTRPC.context<Context>().create() /** * Unprotected procedure */
export const router = t.router
export const middleware = t.middleware

// const isAuthenticated = t.middleware(
//   ({ ctx, next }) => {
//     if (!ctx.user)
//       throw new TRPCError({ code: 'UNAUTHORIZED' })

//     return next({
//       ctx: {
//         user: ctx.user,
//       },
//     })
//   },
// )

export const publicProcedure = t.procedure
// export const protectedProcedure = t.procedure.use(isAuthenticated)
