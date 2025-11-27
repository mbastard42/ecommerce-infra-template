import type { RequestHandler } from '@sveltejs/kit';
import { env } from '$env/dynamic/public';

export const GET: RequestHandler = async () => {
  const backendUrl = env.PUBLIC_BACKEND_URL ?? 'http://backend:8000';

  try {
    const res = await fetch(`${backendUrl}/health`, {
      headers: {
        'Accept': 'application/json'
      }
    });

    const data = await res.json();

    return new Response(JSON.stringify(data), {
      status: res.status,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  } catch (e: any) {
    return new Response(
      JSON.stringify({
        status: 'error',
        services: [],
        error: e?.message ?? 'Unknown error calling Symfony /health'
      }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      }
    );
  }
};