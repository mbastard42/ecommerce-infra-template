from odoo import http
from odoo.http import request
import time

class HealthController(http.Controller):

    @http.route('/health', type='http', auth='none', methods=['GET'], csrf=False)
    def health(self, **kwargs):
        services = {}
        overall_ok = True

        # 1) Postgres truth
        try:
            start = time.time()
            request.env.cr.execute('SELECT 1')
            request.env.cr.fetchone()
            latency = (time.time() - start) * 1000

            services['postgres_truth'] = {
                "status": "ok",
                "latency_ms": round(latency, 1),
            }
        except Exception as e:
            overall_ok = False
            services['postgres_truth'] = {
                "status": "error",
                "latency_ms": None,
                "error": str(e),
            }

        # 2) MinIO via fs.storage (vrai check)
        try:
            fs_storage = request.env['fs.storage'].sudo().search(
                [('code', '=', 'odoofs')],
                limit=1
            )

            if not fs_storage:
                overall_ok = False
                services['minio'] = {
                    "status": "error",
                    "latency_ms": None,
                    "meta": {
                        "error": "No fs.storage found with code 'odoofs'",
                    },
                }
            else:
                fs = fs_storage.fs  # objet DirFileSystem/S3FS déjà configuré

                start = time.time()
                # Opération simple qui oblige à parler à MinIO
                # DirFS est déjà "rooté" sur directory_path, donc '' = racine de ce storage
                fs.ls('')
                latency = (time.time() - start) * 1000

                services['minio'] = {
                    "status": "ok",
                    "latency_ms": round(latency, 1),
                }

        except Exception as e:
            overall_ok = False
            services['minio'] = {
                "status": "error",
                "latency_ms": None,
                "meta": {
                    "error": str(e),
                },
            }

        payload = {
            "status": "ok" if overall_ok else "error",
            "services": services,
        }

        return request.make_json_response(payload)