<script lang="ts">
	import './layout.css';
	import favicon from '$lib/assets/favicon.svg';
  
	let { children } = $props();
  </script>
  
  <svelte:head>
	<link rel="icon" href={favicon} />
  </svelte:head>
  
  <div class="min-h-screen bg-slate-950 text-slate-100 flex flex-col">
	<header class="sticky top-0 z-20 border-b border-slate-800 bg-slate-950/80 backdrop-blur">
	  <div class="max-w-5xl mx-auto px-4 h-14 flex items-center justify-between gap-4">
		<!-- Logo / titre -->
		<div class="flex items-center gap-2">
		  <div class="h-7 w-7 rounded-lg bg-slate-800 flex items-center justify-center text-xs font-semibold">
			3SO
		  </div>
		  <div class="flex flex-col leading-tight">
			<span class="text-sm font-medium">Dev console</span>
			<span class="text-[11px] text-slate-400">Symfony · Odoo · MinIO · Postgres</span>
		  </div>
		</div>
  
		<!-- Nav -->
		<nav class="flex items-center gap-3 text-xs">
		  <!-- Lien interne health -->
		  <a
			href="/health"
			class="inline-flex items-center gap-1.5 rounded-full border border-emerald-500/40 bg-emerald-500/10 px-3 py-1.5
				   font-medium text-emerald-200 shadow-sm hover:bg-emerald-500/20 hover:border-emerald-400
				   transition-colors"
		  >
			<span class="h-1.5 w-1.5 rounded-full bg-emerald-400 animate-pulse" />
			Health
		  </a>
  
		  <!-- Séparateur -->
		  <span class="hidden sm:inline h-4 w-px bg-slate-700/70" />
  
		  <!-- Services externes -->
		  <div class="flex items-center gap-2 overflow-x-auto scrollbar-none">
			<a
			  href="http://localhost:3001"
			  target="_blank"
			  rel="noreferrer"
			  class="inline-flex items-center gap-1.5 rounded-full bg-slate-900/80 px-2.5 py-1.5
					 text-[11px] text-slate-200 border border-slate-700/70 hover:bg-slate-800 hover:border-slate-500
					 whitespace-nowrap transition-colors"
			>
			  <span class="h-1.5 w-1.5 rounded-full bg-sky-400" />
			  Grafana
			</a>
  
			<a
			  href="http://localhost:4200"
			  target="_blank"
			  rel="noreferrer"
			  class="inline-flex items-center gap-1.5 rounded-full bg-slate-900/80 px-2.5 py-1.5
					 text-[11px] text-slate-200 border border-slate-700/70 hover:bg-slate-800 hover:border-slate-500
					 whitespace-nowrap transition-colors"
			>
			  <span class="h-1.5 w-1.5 rounded-full bg-orange-400" />
			  pgAdmin
			</a>
  
			<a
			  href="http://localhost:8069"
			  target="_blank"
			  rel="noreferrer"
			  class="inline-flex items-center gap-1.5 rounded-full bg-slate-900/80 px-2.5 py-1.5
					 text-[11px] text-slate-200 border border-slate-700/70 hover:bg-slate-800 hover:border-slate-500
					 whitespace-nowrap transition-colors"
			>
			  <span class="h-1.5 w-1.5 rounded-full bg-emerald-400" />
			  Odoo
			</a>
  
			<a
			  href="http://localhost:9001"
			  target="_blank"
			  rel="noreferrer"
			  class="inline-flex items-center gap-1.5 rounded-full bg-slate-900/80 px-2.5 py-1.5
					 text-[11px] text-slate-200 border border-slate-700/70 hover:bg-slate-800 hover:border-slate-500
					 whitespace-nowrap transition-colors"
			>
			  <span class="h-1.5 w-1.5 rounded-full bg-lime-400" />
			  MinIO
			</a>
  
			<a
			  href="http://localhost:8000"
			  target="_blank"
			  rel="noreferrer"
			  class="inline-flex items-center gap-1.5 rounded-full bg-slate-900/80 px-2.5 py-1.5
					 text-[11px] text-slate-200 border border-slate-700/70 hover:bg-slate-800 hover:border-slate-500
					 whitespace-nowrap transition-colors"
			>
			  <span class="h-1.5 w-1.5 rounded-full bg-violet-400" />
			  Symfony API
			</a>
		  </div>
		</nav>
	  </div>
	</header>
  
	<main class="flex-1">
	  {@render children()}
	</main>
  </div>