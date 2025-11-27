<script lang="ts">
  import { onMount } from 'svelte';

  type ServiceStatus = {
    name: string;
    status: 'ok' | 'error' | string;
    latency_ms: number | null;
    meta: Record<string, unknown> | null;
  };

  type SystemHealth = {
    status: 'ok' | 'error';
    services: ServiceStatus[];
    error?: string;
  };

  let loading = true;
  let error: string | null = null;
  let health: SystemHealth | null = null;

  async function loadHealth() {
    loading = true;
    error = null;

    try {
      const res = await fetch('/');
      const data = await res.json();
      health = data;
      if (!res.ok) {
        error = data?.error ?? `HTTP ${res.status}`;
      }
    } catch (e: any) {
      error = e?.message ?? 'Erreur inconnue';
    } finally {
      loading = false;
    }
  }

  onMount(loadHealth);
</script>

<div class="min-h-screen bg-slate-950 text-slate-100 flex flex-col">
  <div class="max-w-5xl w-full mx-auto px-4 py-10 space-y-8">
    <!-- Header -->
    <header class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
      <div class="space-y-1">
        <h1 class="text-2xl sm:text-3xl font-semibold tracking-tight flex items-center gap-3">
          System health
          {#if health}
            <span
              class={`inline-flex items-center gap-2 rounded-full px-3 py-1 text-xs font-medium ring-1
                ${health.status === 'ok'
                  ? 'bg-emerald-500/10 text-emerald-300 ring-emerald-500/40'
                  : 'bg-rose-500/10 text-rose-300 ring-rose-500/40'}`}
            >
              <span
                class={`h-2 w-2 rounded-full
                  ${health.status === 'ok' ? 'bg-emerald-400' : 'bg-rose-400'}`}
              />
              {health.status === 'ok' ? 'All systems nominal' : 'Degraded'}
            </span>
          {/if}
        </h1>
        <p class="text-sm text-slate-400">
          Vue consolidée des services back-end (Symfony, Odoo, MinIO, Postgres...).
        </p>
      </div>

      <button
        type="button"
        on:click={loadHealth}
        disabled={loading}
        class="inline-flex items-center justify-center gap-2 rounded-md border border-slate-700 bg-slate-800 px-4 py-2
          text-sm font-medium text-slate-100 shadow-sm transition hover:bg-slate-700 hover:border-slate-600
          disabled:cursor-not-allowed disabled:opacity-60"
      >
        {#if loading}
          <span class="h-3 w-3 animate-spin rounded-full border-[2px] border-slate-100/60 border-t-transparent" />
          <span>Rafraîchissement…</span>
        {:else}
          <span class="h-4 w-4">⟳</span>
          <span>Rafraîchir</span>
        {/if}
      </button>
    </header>

    <!-- Error banner -->
    {#if error}
      <div class="rounded-lg border border-rose-500/40 bg-rose-950/60 px-4 py-3 text-sm text-rose-100 flex gap-3">
        <span class="mt-0.5">⚠️</span>
        <div>
          <p class="font-medium">Erreur lors du chargement de l'état système</p>
          <p class="text-rose-200/80 break-all">{error}</p>
        </div>
      </div>
    {/if}

    <!-- Table / content -->
    <section class="rounded-xl border border-slate-800 bg-slate-900/60 shadow-lg overflow-hidden">
      <div class="border-b border-slate-800 px-4 py-3 flex items-center justify-between text-xs text-slate-400">
        <span>
          Dernière mise à jour :
          {#if loading}
            <span class="italic">chargement…</span>
          {:else}
            <span class="font-mono">{new Date().toLocaleTimeString()}</span>
          {/if}
        </span>
        <span class="hidden sm:inline">
          Statut global :
          {#if health}
            <span class={health.status === 'ok' ? 'text-emerald-300' : 'text-rose-300'}>
              {health.status}
            </span>
          {:else}
            <span class="italic">inconnu</span>
          {/if}
        </span>
      </div>

      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-slate-800 text-sm">
          <thead class="bg-slate-900/80">
            <tr>
              <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-400">
                Service
              </th>
              <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-400">
                Statut
              </th>
              <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-400">
                Latence (ms)
              </th>
              <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-400">
                Détails
              </th>
            </tr>
          </thead>

          <tbody class="divide-y divide-slate-800/80 bg-slate-950/40">
            {#if loading && !health}
              {#each Array(3) as _, i}
                <tr class="animate-pulse" aria-hidden="true">
                  <td class="px-4 py-4">
                    <div class="h-3 w-24 rounded bg-slate-800" />
                  </td>
                  <td class="px-4 py-4">
                    <div class="h-3 w-16 rounded bg-slate-800" />
                  </td>
                  <td class="px-4 py-4">
                    <div class="h-3 w-12 rounded bg-slate-800" />
                  </td>
                  <td class="px-4 py-4">
                    <div class="h-3 w-40 rounded bg-slate-800" />
                  </td>
                </tr>
              {/each}
            {:else if health}
              {#each health.services as s}
                <tr class="hover:bg-slate-900/70 transition-colors">
                  <td class="px-4 py-3 align-top">
                    <div class="flex flex-col gap-0.5">
                      <span class="font-medium text-slate-100">{s.name}</span>
                    </div>
                  </td>
                  <td class="px-4 py-3 align-top">
                    <span
                      class={`inline-flex items-center gap-2 rounded-full px-2.5 py-1 text-xs font-medium
                        ${s.status === 'ok'
                          ? 'bg-emerald-500/10 text-emerald-300 ring-1 ring-emerald-500/30'
                          : 'bg-rose-500/10 text-rose-300 ring-1 ring-rose-500/30'}`}
                    >
                      <span
                        class={`h-2 w-2 rounded-full
                          ${s.status === 'ok' ? 'bg-emerald-400' : 'bg-rose-400'}`}
                      />
                      {s.status}
                    </span>
                  </td>
                  <td class="px-4 py-3 align-top">
                    <span class="font-mono tabular-nums text-slate-100">
                      {s.latency_ms !== null ? s.latency_ms.toFixed(1) : '–'}
                    </span>
                  </td>
                  <td class="px-4 py-3 align-top">
                    {#if s.name === 'odoo' && s.meta && 'services' in s.meta && (s.meta as any).services}
                      <div class="space-y-2">
                        <p class="text-xs font-medium uppercase tracking-wide text-slate-400">
                          Sous-services Odoo
                        </p>
                        <div class="grid gap-2 sm:grid-cols-2">
                          {#each Object.entries((s.meta as any).services ?? {}) as [subName, subData]}
                            <div class="rounded-lg border border-slate-800 bg-slate-950/60 px-3 py-2 space-y-1">
                              <div class="flex items-center justify-between gap-2">
                                <span class="text-xs font-medium text-slate-100">
                                  {subName}
                                </span>
                                {#if (subData as any).status}
                                  <span
                                    class={`inline-flex items-center gap-1.5 rounded-full px-2 py-0.5 text-[11px] font-medium
                                      ${(subData as any).status === 'ok'
                                        ? 'bg-emerald-500/10 text-emerald-300 ring-1 ring-emerald-500/30'
                                        : 'bg-rose-500/10 text-rose-300 ring-1 ring-rose-500/30'}`}
                                  >
                                    <span
                                      class={`h-1.5 w-1.5 rounded-full
                                        ${(subData as any).status === 'ok' ? 'bg-emerald-400' : 'bg-rose-400'}`}
                                    />
                                    {(subData as any).status}
                                  </span>
                                {/if}
                              </div>
                              {#if (subData as any).error}
                                <p class="text-[11px] text-rose-300/90 break-all">
                                  {(subData as any).error}
                                </p>
                              {:else}
                                <p class="text-[11px] text-slate-400">
                                  OK
                                </p>
                              {/if}
                              {#if typeof (subData as any).latency_ms === 'number'}
                                <p class="text-[11px] text-slate-400">
                                  Latence&nbsp;: {(subData as any).latency_ms.toFixed(1)}&nbsp;ms
                                </p>
                              {/if}
                            </div>
                          {/each}
                        </div>
                      </div>
                    {:else if s.meta}
                      <pre class="max-h-32 w-full max-w-xl overflow-auto rounded bg-slate-950/60 px-3 py-2 text-xs text-slate-300">
{JSON.stringify(s.meta, null, 2)}
                      </pre>
                    {:else}
                      <span class="text-xs text-slate-500">Aucun détail</span>
                    {/if}
                  </td>
                </tr>
              {/each}
            {:else}
              <tr>
                <td colspan="4" class="px-4 py-6 text-center text-sm text-slate-500">
                  Aucun résultat pour le moment. Lance un premier rafraîchissement.
                </td>
              </tr>
            {/if}
          </tbody>
        </table>
      </div>
    </section>
  </div>
</div>