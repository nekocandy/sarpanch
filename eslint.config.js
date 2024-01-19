import antfu from '@antfu/eslint-config'
import unoCssPlugin from '@unocss/eslint-config'

export default antfu({
  files: ['./**/*.{vue,js,ts}'],
  vue: true,
  typescript: true,
  plugins: {
    unocss: unoCssPlugin,
  },
})
