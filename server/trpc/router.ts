import { helloRouter } from './routers/hello'
import { router } from './trpc'

export const appRouter = router({
  hello: helloRouter,
})

export type AppRouter = typeof appRouter
