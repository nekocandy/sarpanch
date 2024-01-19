import { publicProcedure, router } from '../trpc'

export const helloRouter = router({
  hi: publicProcedure
    .query(() => {
      return 'Hello World!'
    }),
})
