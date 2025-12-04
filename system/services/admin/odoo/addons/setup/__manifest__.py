# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html)

{
    'name': 'Custom Odoo Setup',
    'version': '1.0',
    'author': 'M4BA',
    'depends': [
        'base',
        'stock',
        'product',
        'sale_management',
        'contacts',
        'server_environment',
        'fs_storage',
        'fs_attachment',
        'health',
    ],
    'auto_install': True,
    'installable': True,
}