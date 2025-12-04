<?php

namespace App\System\Infrastructure\Probe;

use App\System\Domain\Model\ServiceStatus;
use App\System\Domain\Port\HealthProbeInterface;
use Symfony\Contracts\HttpClient\HttpClientInterface;

final class OdooHealthProbe implements HealthProbeInterface
{
    public function __construct(
        private HttpClientInterface $httpClient,
        private string $odooUrl,
    ) {}

    public function name(): string
    {
        return 'odoo';
    }

    public function check(): ServiceStatus
    {
        $start = microtime(true);

        try {
            $response = $this->httpClient->request(
                'GET',
                rtrim($this->odooUrl, '/') . '/health',
                ['timeout' => 3]
            );

            $latency = (microtime(true) - $start) * 1000;
            $body = $response->toArray(false);

            if ($response->getStatusCode() !== 200) {
                return new ServiceStatus(
                    name: $this->name(),
                    status: 'error',
                    latencyMs: round($latency, 1),
                    meta: ['http_status' => $response->getStatusCode()]
                );
            }

            return new ServiceStatus(
                name: $this->name(),
                status: $body['status'] ?? 'ok',
                latencyMs: round($latency, 1),
                meta: [
                    'services' => $body['services'] ?? null,
                ]
            );
        } catch (\Throwable $e) {
            return new ServiceStatus(
                name: $this->name(),
                status: 'error',
                meta: ['error' => $e->getMessage()],
            );
        }
    }
}