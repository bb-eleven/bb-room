<script>
	import { createTransaction } from '$lib/db/create-transaction';

	function click() {
		createTransaction('who', [{ item_variant_id: 28, quantity: 10, to_location_id: 2 }]);
	}
</script>

<ul>
	<button on:click={click}>createTransaction</button>
</ul>
