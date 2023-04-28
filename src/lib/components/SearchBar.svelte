<script lang="ts">
	export let search: string;
</script>

<div class="{$$props.class}">
  <label>
    <input
      type="text"
      placeholder="Search"
      spellcheck="false"
      bind:value={search}
      class="w-full bg-mirage placeholder:text-comet-darker text-comet select-none rounded-md border-2 border-comet p-1 pl-2 active:outline-none focus:outline-none"
    />
  </label>
</div>
