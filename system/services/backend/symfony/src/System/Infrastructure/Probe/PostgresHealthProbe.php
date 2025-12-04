<?php

namespace App\System\Infrastructure\Probe;

use App\System\Domain\Model\ServiceStatus;
use App\System\Domain\Port\HealthProbeInterface;
use Doctrine\ORM\EntityManagerInterface;

final class PostgresHealthProbe implements HealthProbeInterface
{
    public function __construct(
        private EntityManagerInterface $em,
    ) {}

    public function name(): string
    {
        return 'postgres_mirror';
    }

    public function check(): ServiceStatus
    {
        $start = microtime(true);

        try {
            $this->em->getConnection()->executeQuery('SELECT 1')->fetchOne();
            $latency = (microtime(true) - $start) * 1000;

            return new ServiceStatus(
                name: $this->name(),
                status: 'ok',
                latencyMs: round($latency, 1),
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