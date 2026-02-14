import { Link, useLocation } from 'react-router-dom'

const navItems = [
  { path: '/', label: 'HOME' },
  { path: '/marketplace', label: 'MARKETPLACE' },
  { path: '/catalog', label: 'CATALOG' },
  { path: '/journals', label: 'JOURNALS' },
  { path: '/stats', label: 'STATS' },
  { path: '/gift', label: 'GIFT' },
]

export function Navigation() {
  const location = useLocation()

  return (
    <nav className="flex items-center gap-1">
      {navItems.map((item) => {
        const isActive = item.path === '/'
          ? location.pathname === '/'
          : location.pathname.startsWith(item.path)
        return (
          <Link
            key={item.path}
            to={item.path}
            className={`px-3 py-1 font-terminal text-xs transition-all duration-200 ${
              isActive
                ? 'text-green-400 bg-green-500/10'
                : 'text-neutral-600 hover:text-green-400/70'
            }`}
          >
            [{item.label}]
          </Link>
        )
      })}
    </nav>
  )
}
