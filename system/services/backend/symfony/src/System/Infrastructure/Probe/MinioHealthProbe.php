<?php

namespace App\System\Infrastructure\Probe;

use App\System\Domain\Model\ServiceStatus;
use App\System\Domain\Port\HealthProbeInterface;
use Symfony\Contracts\HttpClient\HttpClientInterface;

final class MinioHealthProbe implements HealthProbeInterface
{
    public function __construct(
        private HttpClientInterface $httpClient,
        private string $minioUrl,
        private string $minioBucket,
    ) {}

    public function name(): string
    {
        return 'minio';
    }

    public function check(): ServiceStatus
    {
        $start = microtime(true);

        try {
            $response = $this->httpClient->request(
                'GET',
                rtrim($this->minioUrl, '/') . '/minio/health/ready',
                ['timeout' => 3]
            );

            $latency = (microtime(true) - $start) * 1000;

            if ($response->getStatusCode() >= 200 && $response->getStatusCode() < 400) {
                return new ServiceStatus(
                    name: $this->name(),
                    status: 'ok',
                    latencyMs: round($latency, 1),
                );
            }

            return new ServiceStatus(
                name: $this->name(),
                status: 'error',
                meta: ['http_status' => $response->getStatusCode()]
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