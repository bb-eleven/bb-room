<script lang="ts">
	import { browser } from '$app/environment';
	import Title from '$lib/components/Title.svelte';
	import TextButton from '$lib/components/buttons/TextButton.svelte';
	import Input from '$lib/components/inputs/Input.svelte';
	import InputError from '$lib/components/inputs/InputError.svelte';
	import PasswordInput from '$lib/components/inputs/PasswordInput.svelte';
	import { inou, ninou } from '$lib/utils';
	import type { Nullable } from 'vitest';
	import type { PageData } from './$types';
	import { goto } from '$app/navigation';

	export let data: PageData;

	if (ninou(data.session) && browser) {
		goto('/inventory');
	}

	type Input<T> = {
		value?: Nullable<T>;
		error?: Nullable<T>;
	};

	let username: Input<string> = {};
	let password: Input<string> = {};
	let loginError: Nullable<string>;

	const validateRequired = (input: Input<string>) => {
		if (inou(input.value) || input.value === '') {
			input.error = 'Required';
		} else {
			input.error = null;
		}
		return input;
	};

	const login = async () => {
		username = validateRequired(username);
		password = validateRequired(password);

		if (ninou(username.error) || ninou(password.error)) {
			return;
		}

		const { data: userData, error: userError } = await data.supabase.auth.signInWithPassword({
			email: username.value as string,
			password: password.value as string,
		});

		loginError = userError?.message;
		if (ninou(loginError)) {
			return;
		}

		if (browser && history.state.redirect) {
			goto(history.state.redirect, { replaceState: true });
		} else {
			goto('/inventory');
		}
	};
</script>

<section
	class="absolute top-[50%] left-[50%] -translate-x-[50%] -translate-y-[50%] w-full max-w-[360px] space-y-4"
>
	<InputError error={loginError} />
	<Input
		label="Username"
		bind:value={username.value}
		error={username.error}
		onBlur={() => (username = validateRequired(username))}
	/>
	<PasswordInput
		label="Password"
		bind:value={password.value}
		error={password.error}
		onBlur={() => (password = validateRequired(password))}
	/>
	<div class="flex justify-center">
		<TextButton text="Login" click={login} class="mt-3" />
	</div>
</section>
