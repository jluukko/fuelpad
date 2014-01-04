/*
 * This file is part of Fuelpad.
 *
 * Copyright (C) 2007-2012 Julius Luukko <julle.luukko@quicknet.inet.fi>
 *
 * Fuelpad is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Fuelpad is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Fuelpad.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import CustomComponents 1.0
// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: plot

    property double originX: 0.2*width
    property double originY: 0.8*height
    property double plotWidth: 0.6*width
    property double plotHeight: 0.6*height
    property color penColor: "blue"
    property alias data: dataView.model

    // Coordinate axes
    // y-axis
    Line {
        x1: originX
        y1: originY-plotHeight
        x2: originX
        y2: originY
        penWidth: 3
        color: plot.penColor
    }
    // x-axis
    Line {
        x1: originX
        y1: originY
        x2: originX+plotWidth
        y2: originY
        penWidth: 3
        color: plot.penColor
    }

    ListView {
        id: dataView
        x: originX
        y: originY-plotHeight
        width: plotWidth
        height: plotHeight
        model: data
        delegate: barGraph
    }

    function maxX() {
        var maxVal=0;
        var i;
        for (i=0;i<plotData.count;i++) {
            if (plotData.get(i).xc > maxVal) {
                maxVal = plotData.get(i).xc
            }
        }
        return maxVal
    }

    function minX() {
        var minVal=0;
        var i;
        for (i=0;i<plotData.count;i++) {
            if (plotData.get(i).xc < minVal) {
                minVal = plotData.get(i).xc
            }
        }
        return minVal
    }

    function maxY() {
        var maxVal=0;
        var i;
        for (i=0;i<plotData.count;i++) {
            if (plotData.get(i).yc > maxVal) {
                maxVal = plotData.get(i).yc
            }
        }
        return maxVal
    }

    function minY() {
        var minVal=0;
        var i;
        for (i=0;i<plotData.count;i++) {
            if (plotData.get(i).yc < minVal) {
                minVal = plotData.get(i).yc
            }
        }
        return minVal
    }

    Component {
        id: barGraph
        Item {
            x: xc/(maxX()-minX())*plotWidth*0.9
            y: 0
            Text {
                text: yc
                font.pixelSize: 16
                y: bar.y
            }

            Rectangle {
                id: bar
                width: 10
                height: yc/(maxY()-minY())*plotHeight
                y: plotHeight-yc/(maxY()-minY())*plotHeight
                color: plot.penColor
            }
        }
    }

}
