/**
 * hadui-custom.js
 */

import { HazeWSC } from "/haze.js";

export const HaduiDefaultStmt =
  // the statement shown initially
  `
-- this is what typically entered in web UI, pipe a computation to
-- a plot specification, thus get a plot definition (with data in it),
-- this definition passed to 'uiPlot', to trigger the web browser for
-- visualization.
plotSinCos <$> prepareData >>= uiPlot "demoGroup1"

`;

export class HaduiWSC extends HazeWSC {
  // implement ws methods here
}
