import { flowRouter } from './routers/flowRouter'
import { helloRouter } from './routers/hello'
import { router } from './trpc'

export const appRouter = router({
  hello: helloRouter,
  flowRouter,
})

export type AppRouter = typeof appRouter
