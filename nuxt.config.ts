import { env } from 'std-env'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  ssr: false,
  app: {
    head: {
      title: 'opinionated nuxt',
      meta: [
        {
          name: 'description',
          content: 'an opinionated nuxt starter template',
        },
      ],
      link: [
        {
          rel: 'icon',
          href: '/oink.svg',
        },
      ],
    },
  },
  build: {
    transpile: ['trpc-nuxt'],
  },
  features: {
    inlineStyles: false,
  },
  modules: ['@vueuse/nuxt', 'notivue/nuxt', '@unocss/nuxt', '@sidebase/nuxt-auth', '@formkit/auto-animate/nuxt'],
  css: [
    '@unocss/reset/tailwind.css',
    'notivue/notifications.css',
    'notivue/animations.css',
    'md-editor-v3/lib/style.css',
  ],
  imports: {
    imports: [
      {
        name: 'nanoid',
        from: 'nanoid',
      },
      {
        name: 'consola',
        from: 'consola',
      },
    ],
  },
  auth: {
    isEnabled: false,
  },
  runtimeConfig: {
    auth: {
      SECRET: env.AUTH_SECRET as string,
      DISCORD_CLIENT_ID: env.DISCORD_CLIENT_ID as string,
      DISCORD_CLIENT_SECRET: env.DISCORD_CLIENT_SECRET as string,
    },
    public: {
      NCT_ADDRESS: env.NUXT_PUBLIC_NCT_ADDRESS as string,
    },
  },
})
