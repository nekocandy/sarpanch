import {
  defineConfig,
  presetAttributify,
  presetIcons,
  presetMini,
  presetTypography,
  presetUno,
  presetWebFonts,
  transformerDirectives,
  transformerVariantGroup,
} from 'unocss'

export default defineConfig({
  presets: [
    presetUno(),
    presetAttributify(),
    presetMini({
      attributifyPseudo: true,
    }),
    presetIcons({
      scale: 1.2,
      cdn: 'https://esm.sh/',
    }),
    presetTypography(),
    presetWebFonts({
      fonts: {
        sans: {
          name: 'Inter',
          weights: Array.from({ length: 9 }).fill(0).map((_, i) => i * 100 + 100),
        },
        serif: {
          name: 'Open Sans',
          weights: Array.from({ length: 9 }).fill(0).map((_, i) => i * 100 + 100),
        },
        mono: {
          name: 'JetBrains Mono',
          weights: Array.from({ length: 9 }).fill(0).map((_, i) => i * 100 + 100),
        },
        hindi: {
          name: 'IBM Plex Sans Devanagari',
          weights: Array.from({ length: 9 }).fill(0).map((_, i) => i * 100 + 100),
        },
      },
    }),
  ],
  transformers: [
    transformerDirectives(),
    transformerVariantGroup(),
  ],
})
