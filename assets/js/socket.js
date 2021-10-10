import { Socket } from 'phoenix'

let socket = new Socket('/socket', { params: { token: window.userToken } })
socket.connect()

// GLOBAL VARIABLES
const ID = Math.round(Math.random() * 1000000)
const SOLUTION_CANVAS_CONTEXT = document
  .querySelector('#resultCanvas')
  .getContext('2d')
const SOLUTION_CANVAS_SIZE = 500
let SOLUTION_CANVAS_SCALE = 5
let INSTANCE = null

SOLUTION_CANVAS_CONTEXT.canvas.width = SOLUTION_CANVAS_SIZE
SOLUTION_CANVAS_CONTEXT.canvas.height = SOLUTION_CANVAS_SIZE

const CHANNEL = socket.channel(`solver:${ID}`, {})

CHANNEL.join()
  .receive('ok', (resp) => {
    console.log('Joined successfully', resp)
  })
  .receive('error', (resp) => {
    console.log('Unable to join', resp)
  })

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
    ctx.fillRect(
      x * SOLUTION_CANVAS_SCALE - 2,
      y * SOLUTION_CANVAS_SCALE - 1,
      5,
      3
    )
    ctx.fillRect(
      x * SOLUTION_CANVAS_SCALE - 1,
      y * SOLUTION_CANVAS_SCALE - 2,
      3,
      5
    )
  } else {
    ctx.fillStyle = '#000'
    ctx.fillRect(
      x * SOLUTION_CANVAS_SCALE - 1,
      y * SOLUTION_CANVAS_SCALE - 1,
      3,
      3
    )
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
  let timeout = null

  if (listOfPoints.length <= 30) {
    timeout = 200
  } else {
    timeout = 6000 / listOfPoints.length
  }

  for (let i = 1; i <= listOfPoints.length; i++) {
    setTimeout(() => {
      if (i !== listOfPoints.length) {
        drawLine(ctx, listOfPoints[i - 1], listOfPoints[i])
      } else {
        drawLine(ctx, listOfPoints[listOfPoints.length - 1], listOfPoints[0])
      }
    }, i * timeout)
  }
}

const clearCanvas = (ctx, size) => {
  ctx.fillStyle = '#fff'
  ctx.fillRect(0, 0, size, size)
}

const getInstance = (min, max, count) => {
  let allPoints = [],
    selectedPoints = []

  for (let x = min; x <= max; x++) {
    for (let y = min; y <= max; y++) {
      allPoints.push([x, y])
    }
  }

  for (let n = 0; n < count; n++) {
    const randomIndex = Math.round(Math.random() * (allPoints.length - 1))
    selectedPoints.push({ index: n, coords: allPoints[randomIndex] })
    allPoints.splice(randomIndex, 1)
  }

  return selectedPoints
}

const generateInstance = (min, max, count) => {
  clearCanvas(SOLUTION_CANVAS_CONTEXT, SOLUTION_CANVAS_SIZE)
  SOLUTION_CANVAS_SCALE = SOLUTION_CANVAS_SIZE / max
  INSTANCE = getInstance(min, max, count)

  const parsedPoints = parseCoordsData(INSTANCE)

  drawPoints(SOLUTION_CANVAS_CONTEXT, parsedPoints[1])
}

document.querySelector('#solveGreedy').addEventListener('click', () => {
  solveGreedy()
})

document.querySelector('#generateInstance').addEventListener('click', () => {
  generateInstance(0, 1000, 100)
})

export default socket
