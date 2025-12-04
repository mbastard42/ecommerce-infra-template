<?php

namespace App\System\Infrastructure\Probe;

use App\System\Domain\Model\ServiceStatus;
use App\System\Domain\Port\HealthProbeInterface;

final class SymfonyHealthProbe implements HealthProbeInterface
{
    public function name(): string
    {
        return 'symfony';
    }

    public function check(): ServiceStatus
    {
        return new ServiceStatus(
            name: $this->name(),
            status: 'ok',
            latencyMs: null,
        );
    }
}