<?php

namespace App\System\Infrastructure\Http\Controller;

use App\System\Application\UseCase\CheckSystemHealthHandler;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

final class HealthController extends AbstractController
{
    #[Route('/health', name: 'app_health', methods: ['GET'])]
    public function __invoke(CheckSystemHealthHandler $handler): JsonResponse
    {
        $health = $handler();

        return $this->json(
            $health->toArray(),
            $health->isHealthy() ? 200 : 503
        );
    }
}