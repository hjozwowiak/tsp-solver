import { Socket } from 'phoenix'

let socket = new Socket('/socket', { params: { token: window.userToken } })
socket.connect()

// GLOBAL VARIABLES
const ID = Math.round(Math.random() * 1000000)
const SOLUTION_CANVAS_CONTEXT = document
  .querySelector('#resultCanvas')
  .getContext('2d')
const SOLUTION_CANVAS_SIZE = 500
const SOLUTION_CANVAS_SCALE = 5
let INSTANCE = null

SOLUTION_CANVAS_CONTEXT.canvas.width = SOLUTION_CANVAS_SIZE
SOLUTION_CANVAS_CONTEXT.canvas.height = SOLUTION_CANVAS_SIZE

const CHANNEL = socket.channel(`solver:${ID}`, {})

CHANNEL
  .join()
  .receive('ok', (resp) => {
    console.log('Joined successfully', resp)
  })
  .receive('error', (resp) => {
    console.log('Unable to join', resp)
  })

const generateInstance = () => {
  INSTANCE = [
    { index: 0, coords: [96, 31] },
    { index: 1, coords: [51, 48] },
    { index: 2, coords: [94, 50] },
    { index: 3, coords: [88, 83] },
    { index: 4, coords: [42, 98] },
    { index: 5, coords: [35, 91] },
    { index: 6, coords: [12, 78] },
    { index: 7, coords: [34, 40] },
    { index: 8, coords: [6, 12] },
    { index: 9, coords: [94, 89] },
    { index: 10, coords: [24, 6] },
    { index: 11, coords: [41, 31] },
    { index: 12, coords: [87, 20] },
    { index: 13, coords: [79, 92] },
    { index: 14, coords: [76, 23] },
    { index: 15, coords: [65, 87] },
    { index: 16, coords: [34, 55] },
    { index: 17, coords: [14, 82] },
    { index: 18, coords: [6, 59] },
    { index: 19, coords: [65, 7] },
  ]

  const parsedPoints = parseCoordsData(INSTANCE)
  drawPoints(SOLUTION_CANVAS_CONTEXT, parsedPoints[1])
}

const solveGreedy = () => {
  CHANNEL.push('solve', {
    body: INSTANCE,
  })
}

CHANNEL.on('solution', (payload) => {
  const parsedPoints = parseCoordsData(payload.body)

  drawPath(SOLUTION_CANVAS_CONTEXT, parsedPoints[1])
})

const parseCoordsData = (data) => {
  let indexes = []
  let points = []

  data.forEach((entry) => {
    indexes.push(entry.index)
    points.push(entry.coords)
  })

  return [indexes, points]
}

const drawSinglePoint = (ctx, [x, y], pointType) => {
  if (pointType === 'big') {
    ctx.fillStyle = '#f00'
    ctx.fillRect(x * SOLUTION_CANVAS_SCALE - 2, y * SOLUTION_CANVAS_SCALE - 1, 5, 3)
    ctx.fillRect(x * SOLUTION_CANVAS_SCALE - 1, y * SOLUTION_CANVAS_SCALE - 2, 3, 5)
  } else {
    ctx.fillStyle = '#000'
    ctx.fillRect(x * SOLUTION_CANVAS_SCALE - 1, y * SOLUTION_CANVAS_SCALE - 1, 3, 3)
  }
}

const drawPoints = (ctx, listOfPoints) => {
  listOfPoints.forEach((point, index) => {
    if (index === 0) {
      drawSinglePoint(ctx, point, 'big')
    } else {
      drawSinglePoint(ctx, point)
    }
  })
}

const drawLine = (ctx, [x1, y1], [x2, y2]) => {
  ctx.moveTo(x1 * SOLUTION_CANVAS_SCALE, y1 * SOLUTION_CANVAS_SCALE)
  ctx.lineTo(x2 * SOLUTION_CANVAS_SCALE, y2 * SOLUTION_CANVAS_SCALE)
  ctx.stroke()
}

const drawPath = (ctx, listOfPoints) => {
  for (let i = 1; i <= listOfPoints.length; i++) {
    setTimeout(() => {
      if (i !== listOfPoints.length) {
        drawLine(ctx, listOfPoints[i - 1], listOfPoints[i])
      } else {
        drawLine(ctx, listOfPoints[listOfPoints.length - 1], listOfPoints[0])
      }
    }, i * 250)
  }
}

document.querySelector('#solveGreedy').addEventListener('click', () => {
  solveGreedy()
})

document.querySelector('#generateInstance').addEventListener('click', () => {
  generateInstance()
})

export default socket
