export type Errors = { message: string }[];
export type Result<T> = { result?: T; errors?: Errors };
