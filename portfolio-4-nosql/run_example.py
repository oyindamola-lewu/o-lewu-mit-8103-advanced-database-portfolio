"""Store and look up fictional Aster Bank profiles in a key-value database."""
import dbm
import json
from pathlib import Path
from tempfile import TemporaryDirectory

FOLDER = Path(__file__).resolve().parent
profiles = json.loads((FOLDER / 'customer_profiles.json').read_text())
lines = []

with TemporaryDirectory() as temporary_folder:
    with dbm.open(str(Path(temporary_folder) / 'profiles'), 'n') as store:
        for key, profile in profiles.items():
            store[key.encode()] = json.dumps(profile).encode()

        keys = [key.decode() if isinstance(key, bytes) else key for key in store.keys()]
        lines.append('Stored keys: ' + ', '.join(sorted(keys)))

        ada = json.loads(store[b'customer:1'].decode())
        lines.append('Read customer:1: ' + ada['full_name'])
        lines.append('Ada SMS alerts before update: ' + str(ada['notification_preferences']['sms']))

        ada['notification_preferences']['sms'] = True
        store[b'customer:1'] = json.dumps(ada).encode()
        updated_ada = json.loads(store[b'customer:1'].decode())
        lines.append('Ada SMS alerts after update: ' + str(updated_ada['notification_preferences']['sms']))

        tunde = json.loads(store[b'customer:2'].decode())
        lines.append('Read customer:2: ' + tunde['full_name'])
        lines.append('Tunde preferred language: ' + tunde['preferred_language'])

        missing = store.get(b'customer:3')
        lines.append('Read customer:3: ' + ('not found' if missing is None else 'found'))

output = '\n'.join(lines) + '\n'
(FOLDER / 'results.txt').write_text(output)
print(output, end='')
