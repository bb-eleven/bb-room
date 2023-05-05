<script lang="ts">
	export let search: string;
	export let placeholder = 'Search';
	export let onBlur = () => {};
</script>

<div class={$$props.class}>
	<label>
		<input
			type="text"
			{placeholder}
			spellcheck="false"
			bind:value={search}
			on:blur={onBlur}
			class="w-full bg-mirage placeholder:text-comet-darker text-comet select-none rounded-md border-2 border-comet p-1 pl-2 active:outline-none focus:outline-none"
		/>
	</label>
</div>
