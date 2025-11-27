<?php

namespace App\System\Application\UseCase;

use App\System\Domain\Model\SystemHealth;
use App\System\Domain\Port\HealthProbeInterface;

final class CheckSystemHealthHandler
{
    /**
     * @param iterable<HealthProbeInterface> $probes
     */
    public function __construct(
        private iterable $probes,
    ) {}

    public function __invoke(): SystemHealth
    {
        $statuses = [];

        foreach ($this->probes as $probe) {
            $statuses[] = $probe->check();
        }

        return new SystemHealth($statuses);
    }
}