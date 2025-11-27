<?php

namespace App\System\Domain\Port;

use App\System\Domain\Model\ServiceStatus;

interface HealthProbeInterface
{
    public function name(): string;
    public function check(): ServiceStatus;
}