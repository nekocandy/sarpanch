import type { CurrentUser } from '@onflow/typedefs'
import { ref } from 'vue'

export const userData = ref<CurrentUser | null>()
export const TransactionModals = ref<{
  title: string
  transactionId: string
}[]>([])
