<script lang="ts">
	export let label: string;
	export let value = '';
	export let placeholder = 'type...';
	export let onBlur = () => {};
</script>

<div class={$$props.class}>
	<div class="text-blue-600 text-sm mb-2">{label}</div>
	<div>
		<input
			{placeholder}
			spellcheck="false"
			bind:value
			on:blur={onBlur}
			class="px-4 py-1.5 w-full bg-blue-200 placeholder:text-blue-400 text-blue-600 select-none rounded-xl border-2 border-blue-400 active:outline-none focus:outline-none"
		/>
	</div>
</div>
