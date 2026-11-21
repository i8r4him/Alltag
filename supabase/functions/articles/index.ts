// Entry point for Supabase; the code and its notes are in handler.ts, so the tests can import it.
import { handle } from "./handler.ts";

Deno.serve(handle);
