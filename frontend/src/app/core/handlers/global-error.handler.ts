import { ErrorHandler, Injectable } from '@angular/core';

@Injectable()
export class GlobalErrorHandler implements ErrorHandler {

  handleError(error: any): void {
    // Safely log the error — this runs even before Angular is fully initialized
    const message = error?.message || error?.toString() || 'Unknown error';
    console.error('[DealerConnect] Unhandled UI Error:', message, error);

    // Re-throw so Angular's internal error reporting still works
    // (prevents the app from silently swallowing bootstrap errors)
    // We do NOT re-throw here intentionally — this keeps the app alive after runtime errors
  }
}
