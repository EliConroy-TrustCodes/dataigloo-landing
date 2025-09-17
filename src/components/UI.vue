<template>
  <!-- Layout Components -->
</template>

<script setup>
import { ArrowRight } from 'lucide-vue-next'

const brand = {
  bg: "#0B0C0E",
  ink: "#F4F4F5",
  mute: "#A1A1AA",
  line: "rgba(255,255,255,0.12)",
  accent: "#8AB4FF",
}
</script>

<script>
import { h } from 'vue'
import { ArrowRight } from 'lucide-vue-next'

const brand = {
  bg: "#0B0C0E",
  ink: "#F4F4F5",
  mute: "#A1A1AA",
  line: "rgba(255,255,255,0.12)",
  accent: "#8AB4FF",
}

export const Eyebrow = (props, { slots }) => h('div', {
  class: "mb-3 text-[11px] tracking-[0.22em] uppercase text-white/50"
}, slots.default?.())

export const H1 = (props, { slots }) => h('h1', {
  class: "text-4xl md:text-6xl font-extrabold tracking-tight leading-[1.05] text-white"
}, slots.default?.())

export const H2 = (props, { slots }) => h('h2', {
  class: "text-3xl md:text-5xl font-semibold tracking-tight text-white"
}, slots.default?.())

export const P = (props, { slots }) => h('p', {
  class: `text-base md:text-lg leading-relaxed text-white/80 ${props.class || ''}`
}, slots.default?.())

export const Rule = () => h('div', {
  class: "h-px w-full",
  style: { background: brand.line }
})

export const Button = (props, { slots }) => {
  const base = "inline-flex items-center gap-2 px-4 py-2 text-sm font-semibold transition"
  const styles = {
    primary: `${base} rounded-[10px] bg-white text-black hover:opacity-90`,
    ghost: `${base} rounded-[10px] border border-white/15 text-white hover:bg-white/5`,
    link: `${base} p-0 text-white hover:text-[${brand.accent}]`,
  }

  // If type is specified, render as button element (for forms)
  if (props.type === 'submit' || props.type === 'button') {
    const buttonStyles = props.disabled
      ? `${styles[props.variant] || styles.primary} opacity-50 cursor-not-allowed`
      : styles[props.variant] || styles.primary

    return h('button', {
      type: props.type,
      class: buttonStyles,
      disabled: props.disabled,
      onClick: props.onClick
    }, [
      slots.default?.(),
      !props.hideArrow && h(ArrowRight, { class: "h-4 w-4" })
    ])
  }

  // Otherwise render as link
  return h('a', {
    href: props.href || "#",
    class: styles[props.variant] || styles.primary
  }, [
    slots.default?.(),
    h(ArrowRight, { class: "h-4 w-4" })
  ])
}

export const GridBG = () => h('div', {
  'aria-hidden': true,
  class: "pointer-events-none absolute inset-0 -z-10 overflow-hidden"
}, [
  h('div', {
    class: "absolute left-1/2 top-[-10rem] h-[40rem] w-[40rem] -translate-x-1/2 rounded-full blur-3xl",
    style: { background: "radial-gradient(closest-side, rgba(138,180,255,0.18), transparent 70%)" }
  }),
  h('svg', {
    class: "absolute inset-0 h-full w-full opacity-[0.07]",
    xmlns: "http://www.w3.org/2000/svg"
  }, [
    h('defs', [
      h('pattern', {
        id: "grid",
        width: "32",
        height: "32",
        patternUnits: "userSpaceOnUse"
      }, [
        h('path', {
          d: "M32 0H0V32",
          fill: "none",
          stroke: "white",
          'stroke-width': "0.5"
        })
      ])
    ]),
    h('rect', {
      width: "100%",
      height: "100%",
      fill: "url(#grid)"
    })
  ])
])

export const Feature = (props, { slots }) => h('div', {
  class: "group rounded-xl border border-white/10 bg-white/[0.03] p-6 hover:bg-white/[0.05]"
}, [
  h('div', { class: "mb-3 flex items-center gap-3" }, [
    h('div', { class: "flex h-9 w-9 items-center justify-center rounded-md border border-white/15 bg-white/[0.04]" }, [
      h(props.icon, { class: "h-4 w-4 text-white" })
    ]),
    h('div', { class: "text-base font-semibold text-white" }, props.title)
  ]),
  h('div', { class: "text-sm leading-relaxed text-white/75" }, slots.default?.())
])
</script>