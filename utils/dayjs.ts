// exported from utils to extend plugins in dayjs, not possible from nuxt imports
import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import dayOfYear from 'dayjs/plugin/dayOfYear'
import duration from 'dayjs/plugin/duration'

dayjs.extend(dayOfYear)
dayjs.extend(relativeTime)
dayjs.extend(duration)

export default dayjs
