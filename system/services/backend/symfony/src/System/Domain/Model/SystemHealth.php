<?php

namespace App\System\Domain\Model;

final class SystemHealth
{
    /**
     * @param ServiceStatus[] $services
     */
    public function __construct(
        public readonly array $services
    ) {}

    public function isHealthy(): bool
    {
        foreach ($this->services as $service) {
            if (!$service->isOk()) {
                return false;
            }
        }
        return true;
    }

    public function toArray(): array
    {
        return [
            'status' => $this->isHealthy() ? 'ok' : 'error',
            'services' => array_map(
                fn (ServiceStatus $s) => [
                    'name' => $s->name,
                    'status' => $s->status,
                    'latency_ms' => $s->latencyMs,
                    'meta' => $s->meta,
                ],
                $this->services
            ),
        ];
    }
}