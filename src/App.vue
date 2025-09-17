<template>
  <div class="min-h-screen w-full" :style="{ background: brand.bg }">
    <GridBG />

    <!-- NAV -->
    <header class="sticky top-0 z-20 backdrop-blur supports-[backdrop-filter]:bg-black/20">
      <div class="mx-auto w-full max-w-[1200px] px-6 flex items-center justify-between py-5">
        <a href="#top" class="flex items-center gap-3 text-white">
          <Logo />
          <span class="text-sm text-white/70">Dataigloo</span>
        </a>
        <nav class="hidden items-center gap-7 text-sm text-white/70 md:flex">
          <a class="hover:text-white" href="#why">Why</a>
          <a class="hover:text-white" href="#how">How</a>
          <a class="hover:text-white" href="#benefits">Benefits</a>
          <a class="hover:text-white" href="#architecture">Architecture</a>
          <a class="hover:text-white" href="#compliance">Compliance</a>
          <a class="hover:text-white" href="#pricing">Pricing</a>
          <Button href="#contact" variant="ghost">Talk to us</Button>
        </nav>
      </div>
      <Rule />
    </header>

    <!-- HERO -->
    <section id="top" class="relative pt-16">
      <div class="mx-auto w-full max-w-[1200px] px-6 grid items-end gap-10 md:grid-cols-12 md:gap-12">
        <div class="md:col-span-7">
          <Eyebrow>Regional NZ • 1–2 PB micro‑data centres • AU soon</Eyebrow>
          <H1>
            Sovereign <span class="bg-clip-text text-transparent" :style="{ backgroundImage: `linear-gradient(90deg, ${brand.ink}, ${brand.accent})` }">cold data storage</span> for enterprises.
          </H1>
          <P class="mt-5 max-w-[50ch]">
            Offload inactive and compliance data to air‑gapped, WORM‑capable vaults with policy‑based tiering and audit‑ready integrity — all within New Zealand jurisdiction.
          </P>
          <div class="mt-7 flex flex-wrap items-center gap-3">
            <Button href="#contact">Book a workshop</Button>
            <Button href="#how" variant="ghost">See how it works</Button>
          </div>
        </div>
        <div class="md:col-span-5">
          <div
            v-motion-slide-visible-once-bottom
            class="rounded-2xl border border-white/10 bg-white/[0.03] p-6"
          >
            <div class="grid grid-cols-2 gap-4">
              <Feature :icon="Server" title="Cold vaults">Air‑gapped, integrity‑verified, WORM‑capable storage tiers.</Feature>
              <Feature :icon="Gauge" title="Policy tiering">Automate move‑down by age, class, or tags you define.</Feature>
              <Feature :icon="Lock" title="Sovereign keys">AES‑256 at rest, TLS in flight, BYOE/HSM options.</Feature>
              <Feature :icon="FileCheck2" title="Audit‑ready">Chain‑of‑custody, immutable checksums, exportable logs.</Feature>
            </div>
          </div>
        </div>
      </div>
      <div class="mx-auto w-full max-w-[1200px] px-6 mt-10">
        <Rule />
        <div class="flex flex-wrap items-center gap-4 py-4 text-xs text-white/60">
          <span class="uppercase tracking-widest">Trusted by</span>
          <span class="h-4 w-px" :style="{ background: brand.line }" />
          <span>Finance</span>
          <span>Healthcare</span>
          <span>Government</span>
          <span>Legal</span>
          <span>Research</span>
          <span>Manufacturing</span>
        </div>
        <Rule />
      </div>
    </section>

    <!-- WHY -->
    <section id="why" class="relative">
      <div class="mx-auto w-full max-w-[1200px] px-6 py-20 md:py-28">
        <Eyebrow>The case for cold</Eyebrow>
        <H2>Why cold data storage?</H2>
        <div class="mt-8 grid gap-3 md:grid-cols-2">
          <div
            v-for="(item, i) in whyItems"
            :key="i"
            class="rounded-xl border border-white/10 bg-white/[0.03] p-5 text-white/80"
          >
            {{ item }}
          </div>
        </div>
      </div>
      <Rule />
    </section>

    <!-- HOW -->
    <section id="how" class="relative">
      <div class="mx-auto w-full max-w-[1200px] px-6 py-20 md:py-28">
        <Eyebrow>From hot to cold, automatically</Eyebrow>
        <H2>How it works</H2>
        <div class="mt-10 grid gap-6 md:grid-cols-3">
          <Feature :icon="Cloud" title="1. Ingest hot">New or frequently accessed data lives on production or cloud tiers to meet performance SLAs.</Feature>
          <Feature :icon="Layers" title="2. Detect inactivity">Policy thresholds (e.g., no reads for 90 days) flag candidates for tiering.</Feature>
          <Feature :icon="Shield" title="3. Tier to cold">Move inactive data to sovereign, air‑gapped vaults with WORM + integrity checks. Retrieve on demand.</Feature>
        </div>
      </div>
      <Rule />
    </section>

    <!-- BENEFITS -->
    <section id="benefits" class="relative">
      <div class="mx-auto w-full max-w-[1200px] px-6 py-20 md:py-28">
        <Eyebrow>Operational & financial</Eyebrow>
        <H2>Benefits at a glance</H2>
        <div class="mt-10 grid gap-6 md:grid-cols-2">
          <div
            v-for="(benefit, i) in benefits"
            :key="i"
            class="rounded-xl text-white border border-white/10 bg-white/[0.03] p-5"
          >
            {{ benefit }}
          </div>
        </div>
      </div>
      <Rule />
    </section>

    <!-- ARCHITECTURE -->
    <section id="architecture" class="relative">
      <div class="mx-auto w-full max-w-[1200px] px-6 py-20 md:py-28">
        <Eyebrow>Enterprise‑ready</Eyebrow>
        <H2>Architecture & Security</H2>
        <div class="mt-10 grid gap-8 md:grid-cols-2">
          <ul class="space-y-3 text-white/80">
            <li v-for="(item, i) in architectureLeft" :key="i">{{ item }}</li>
          </ul>
          <ul class="space-y-3 text-white/80">
            <li v-for="(item, i) in architectureRight" :key="i">{{ item }}</li>
          </ul>
        </div>
      </div>
      <Rule />
    </section>

    <!-- COMPLIANCE -->
    <section id="compliance" class="relative">
      <div class="mx-auto w-full max-w-[1200px] px-6 py-20 md:py-28">
        <Eyebrow>NZ first, AU next</Eyebrow>
        <H2>Compliance & Sovereignty</H2>
        <div class="mt-10 grid gap-6 md:grid-cols-2">
          <div class="rounded-xl border border-white/10 text-white bg-white/[0.03] p-5">Data remains within your selected jurisdiction. Built to support NZ Privacy Act 2020 obligations, archives/public‑records retention, and sector regulators (e.g., FMA/RBNZ guidance).</div>
          <div class="rounded-xl border border-white/10 text-white bg-white/[0.03] p-5">Court‑ready integrity with WORM, chain‑of‑custody, and hash validation. Export audit reports for internal/external reviewers.</div>
        </div>
      </div>
      <Rule />
    </section>

    <!-- PRICING -->
    <section id="pricing" class="relative">
      <div class="mx-auto w-full max-w-[1200px] px-6 py-20 md:py-28">
        <Eyebrow>Predictable TCO</Eyebrow>
        <H2>Transparent pricing</H2>
        <div class="mt-8 rounded-2xl border border-white/10 bg-white/[0.03] p-6">
          <P>Simple per‑TB per‑month pricing for cold storage. One‑time ingest (waived above agreed volumes). Standard retrieval included; expedited and emergency retrieval available. Optional dual‑site replication and NZ↔AU cross‑border add‑ons.</P>
          <div class="mt-5"><Button href="#contact">Get a tailored quote</Button></div>
        </div>
      </div>
      <Rule />
    </section>

    <!-- CONTACT -->
    <section id="contact" class="relative">
      <div class="mx-auto w-full max-w-[1200px] px-6 py-20 md:py-28">
        <Eyebrow>Contact</Eyebrow>
        <H2>Come on the journey with us</H2>
        <div class="mt-10 grid gap-10 md:grid-cols-2">
          <form @submit.prevent="handleSubmit" class="rounded-2xl border border-white/10 bg-white/[0.03] p-6">
            <div class="grid gap-4">
              <label class="block text-sm text-white/70">
                Name
                <input
                  v-model="form.name"
                  required
                  class="mt-1 w-full rounded-md border border-white/15 bg-transparent px-3 py-2 outline-none focus:border-white/30 text-white"
                  placeholder="Your name"
                />
              </label>
              <label class="block text-sm text-white/70">
                Work email
                <input
                  v-model="form.email"
                  type="email"
                  required
                  class="mt-1 w-full rounded-md border border-white/15 bg-transparent px-3 py-2 outline-none focus:border-white/30 text-white"
                  placeholder="you@company.com"
                />
              </label>
              <label class="block text-sm text-white/70">
                Company
                <input
                  v-model="form.company"
                  class="mt-1 w-full rounded-md border border-white/15 bg-transparent px-3 py-2 outline-none focus:border-white/30 text-white"
                  placeholder="Organisation"
                />
              </label>
              <label class="block text-sm text-white/70">
                How can we help?
                <textarea
                  v-model="form.message"
                  rows="4"
                  class="mt-1 w-full rounded-md border border-white/15 bg-transparent px-3 py-2 outline-none focus:border-white/30 text-white"
                  placeholder="Tell us about your data footprint, retention needs, and timelines."
                />
              </label>
              <Button type="submit" :disabled="isLoading" :hideArrow="isLoading">
                <span v-if="isLoading">Sending...</span>
                <span v-else>Send</span>
              </Button>
              <div v-if="sent" class="text-sm text-emerald-300">Thanks — we'll be in touch shortly.</div>
              <div v-if="error" class="text-sm text-red-300">{{ error }}</div>
            </div>
          </form>
          <div class="space-y-6">
            <div class="rounded-2xl border border-white/10 bg-white/[0.03] p-6">
              <div class="text-xl font-semibold text-white">Contact details</div>
              <div class="mt-3 grid gap-2 text-white/80">
                <div>{{ siteConfig.contactEmail }}</div>
                <div>{{ siteConfig.phone }}</div>
                <div>Regional NZ • AU coming soon</div>
                <div><a class="underline" :href="siteConfig.linkedIn">LinkedIn</a></div>
              </div>
            </div>
            <div class="rounded-2xl border border-white/10 bg-white/[0.03] p-6">
              <div class="text-xl font-semibold text-white">Integration options</div>
              <P class="mt-2">S3‑compatible gateway • NFS/SMB archive tier • Secure file drop • Bulk device ingest • APIs & webhooks • SIEM/SOAR hooks</P>
            </div>
          </div>
        </div>
      </div>
      <Rule />
    </section>

    <!-- FOOTER -->
    <footer>
      <div class="mx-auto w-full max-w-[1200px] px-6 flex flex-col items-start justify-between gap-4 py-10 md:flex-row md:items-center">
        <div class="flex items-center gap-3 text-white/80">
          <Logo />
          <span class="text-sm">© {{ currentYear }} Dataigloo</span>
        </div>
        <div class="text-sm text-white/60">Sovereign cold data storage in New Zealand • Australia coming soon • Now with EmailJS</div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import emailjs from '@emailjs/browser'
import {
  ArrowRight,
  Shield,
  Lock,
  Server,
  Layers,
  FileCheck2,
  Cloud,
  Gauge
} from 'lucide-vue-next'
import Logo from './components/Logo.vue'
import { Eyebrow, H1, H2, P, Rule, Button, GridBG, Feature } from './components/UI.vue'

// Brand tokens
const brand = {
  bg: "#0B0C0E",
  ink: "#F4F4F5",
  mute: "#A1A1AA",
  line: "rgba(255,255,255,0.12)",
  accent: "#8AB4FF",
}

// Form state
const sent = ref(false)
const isLoading = ref(false)
const error = ref(null)
const form = ref({
  name: '',
  email: '',
  company: '',
  message: ''
})

// Site configuration
const siteConfig = {
  domain: import.meta.env.VITE_DOMAIN || 'dataigloo.nz',
  siteUrl: import.meta.env.VITE_SITE_URL || 'https://dataigloo.nz',
  contactEmail: import.meta.env.VITE_CONTACT_EMAIL || 'hello@dataigloo.nz',
  phone: import.meta.env.VITE_PHONE_NUMBER || '+64 (0) ...',
  linkedIn: import.meta.env.VITE_LINKEDIN_URL || 'https://www.linkedin.com/company/dataigloo'
}

// EmailJS configuration - these will come from environment variables
const emailjsConfig = {
  serviceId: import.meta.env.VITE_EMAILJS_SERVICE_ID || 'your_service_id',
  templateId: import.meta.env.VITE_EMAILJS_TEMPLATE_ID || 'your_template_id',
  publicKey: import.meta.env.VITE_EMAILJS_PUBLIC_KEY || 'your_public_key'
}

// Computed
const currentYear = computed(() => new Date().getFullYear())

// Data arrays
const whyItems = [
  "Prevent primary storage overload",
  "Utilise economical cold media",
  "Reduce total storage TCO",
  "Simplify management via policy tiering",
  "Meet compliance & governance efficiently"
]

const benefits = [
  "Optimise hot tiers for performance — push inactive data to low‑cost cold media.",
  "Reduce storage bills and carbon impact with efficient cold lanes.",
  "Automate governance with audit‑ready movements and retention rules.",
  "Strengthen legal defensibility via WORM, hashes, and chain‑of‑custody."
]

const architectureLeft = [
  "Modular micro‑data centres (1–2 PB each) in regional NZ; AU region coming soon",
  "Air‑gapped cold lanes with scheduled access windows",
  "WORM & retention locks for evidential integrity",
  "AES‑256 at rest, TLS 1.3 in flight, BYOE/HSM options"
]

const architectureRight = [
  "Zero‑trust ops (RBAC, MFA, JIT admin) + tamper‑evident logs",
  "Integrity scrubbing & bit‑rot remediation via checksums",
  "Dual‑site & cross‑island replication options",
  "Audit trails, retrieval logs, and environmental telemetry"
]

// Methods
const handleSubmit = async () => {
  if (isLoading.value) return

  isLoading.value = true
  error.value = null

  try {
    // Initialize EmailJS with your public key
    emailjs.init(emailjsConfig.publicKey)

    // Send email using EmailJS
    const result = await emailjs.send(
      emailjsConfig.serviceId,
      emailjsConfig.templateId,
      {
        from_name: form.value.name,
        from_email: form.value.email,
        company: form.value.company,
        message: form.value.message,
        to_email: siteConfig.contactEmail
      }
    )

    console.log('Email sent successfully:', result)
    sent.value = true

    // Reset form
    form.value = {
      name: '',
      email: '',
      company: '',
      message: ''
    }

  } catch (err) {
    console.error('Email send failed:', err)
    error.value = 'Failed to send message. Please try again or contact us directly.'
  } finally {
    isLoading.value = false
  }
}
</script>

