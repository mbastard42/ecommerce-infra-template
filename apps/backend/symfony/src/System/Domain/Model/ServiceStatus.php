<?php

namespace App\System\Domain\Model;

final class ServiceStatus
{
    public function __construct(
        public readonly string $name,
        public readonly string $status, // 'ok' | 'error'
        public readonly ?float $latencyMs = null,
        public readonly ?array $meta = null,
    ) {}

    public function isOk(): bool
    {
        return $this->status === 'ok';
    }
}