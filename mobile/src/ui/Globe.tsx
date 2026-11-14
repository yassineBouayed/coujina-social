/**
 * Le globe du Tour du monde : une Terre en projection orthographique, que
 * l'on fait tourner au doigt, avec une épingle par pays qui a des recettes.
 *
 * Tout est en SVG (react-native-svg + d3-geo) : pas de WebGL, pas de clé de
 * carte, fonctionne dans Expo Go et sur le web. Les côtes viennent de
 * world-atlas (Natural Earth 1:110m, domaine public).
 */
import React, { useMemo, useRef, useState } from 'react';
import { PanResponder, Pressable, StyleSheet, View } from 'react-native';
import Svg, { Circle, Defs, Path, RadialGradient, Stop } from 'react-native-svg';
import { geoDistance, geoGraticule10, geoOrthographic, geoPath } from 'd3-geo';
import { feature } from 'topojson-client';
import type { FeatureCollection, Geometry } from 'geojson';
import land110 from 'world-atlas/land-110m.json';

import { brand, color } from '../theme';
import type { Country } from '../types';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const LAND = feature(land110 as any, (land110 as any).objects.land) as unknown as FeatureCollection<Geometry>;
const GRATICULE = geoGraticule10();

export type GlobeRotation = [number, number];

export function Globe({
  size,
  countries,
  selected,
  onSelect,
  rotation,
  onRotate,
}: {
  size: number;
  countries: Country[];
  selected: string | null;
  onSelect: (slug: string) => void;
  rotation: GlobeRotation;
  onRotate: (next: GlobeRotation) => void;
}) {
  const start = useRef<GlobeRotation>(rotation);
  const live = useRef(rotation);
  live.current = rotation;
  const [dragging, setDragging] = useState(false);

  const r = size / 2 - 4;
  const projection = useMemo(
    () => geoOrthographic().scale(r).translate([size / 2, size / 2]).clipAngle(90).rotate([rotation[0], rotation[1]]),
    [r, size, rotation],
  );
  const path = useMemo(() => geoPath(projection), [projection]);
  const landPath = useMemo(() => path(LAND) ?? '', [path]);
  const gridPath = useMemo(() => path(GRATICULE) ?? '', [path]);

  // Le point au centre de l'écran, pour savoir quelles épingles sont de face.
  const center: [number, number] = [-rotation[0], -rotation[1]];

  const responder = useMemo(
    () =>
      PanResponder.create({
        onStartShouldSetPanResponder: () => false,
        onMoveShouldSetPanResponder: (_e, g) => Math.abs(g.dx) + Math.abs(g.dy) > 4,
        onPanResponderGrant: () => {
          start.current = live.current;
          setDragging(true);
        },
        onPanResponderMove: (_e, g) => {
          const k = 180 / (Math.PI * r); // un rayon parcouru = 57°
          const lng = start.current[0] + g.dx * k;
          const lat = Math.max(-70, Math.min(70, start.current[1] - g.dy * k));
          onRotate([lng, lat]);
        },
        // Le globe garde le geste : sans ça, la page qui défile le lui vole.
        onPanResponderTerminationRequest: () => false,
        onPanResponderRelease: () => setDragging(false),
        onPanResponderTerminate: () => setDragging(false),
      }),
    [onRotate, r],
  );

  return (
    <View style={{ width: size, height: size }} {...responder.panHandlers}>
      <Svg width={size} height={size}>
        <Defs>
          <RadialGradient id="ocean" cx="40%" cy="35%" r="70%">
            <Stop offset="0" stopColor="#F7EFE4" />
            <Stop offset="1" stopColor="#E7DCCE" />
          </RadialGradient>
        </Defs>
        <Circle cx={size / 2} cy={size / 2} r={r} fill="url(#ocean)" stroke={color.borderDark} strokeWidth={1} />
        <Path d={gridPath} stroke={color.borderStrong} strokeWidth={0.5} fill="none" />
        <Path d={landPath} fill="#CDBBA6" stroke="#B9A48C" strokeWidth={0.6} />
      </Svg>
      {/* Les épingles sont des vues, pas des cercles SVG : un onPress sur du SVG
          n'arrive pas sur le web, et la zone de toucher se règle mieux ici. */}
      {countries.map((c) => {
        if (!c.recipe_count) return null;
        if (geoDistance([c.lng, c.lat], center) > Math.PI / 2 - 0.05) return null; // de dos
        const p = projection([c.lng, c.lat]);
        if (!p) return null;
        const on = c.slug === selected;
        const dot = 2 * (on ? 14 : Math.min(11, 5 + Math.sqrt(c.recipe_count) * 0.9));
        const hit = Math.max(dot, 34);
        return (
          <Pressable
            key={c.slug}
            accessibilityRole="button"
            accessibilityLabel={c.name}
            onPress={() => !dragging && onSelect(c.slug)}
            hitSlop={4}
            style={[s.hit, { left: p[0] - hit / 2, top: p[1] - hit / 2, width: hit, height: hit }]}>
            <View
              style={[
                s.pin,
                { width: dot, height: dot, borderRadius: dot / 2, backgroundColor: on ? brand.ember : brand.plum },
              ]}
            />
          </Pressable>
        );
      })}
    </View>
  );
}

/** Tourne le globe pour mettre un pays face à soi. */
export const rotationFor = (c: Pick<Country, 'lat' | 'lng'>): GlobeRotation => [-c.lng, -Math.max(-70, Math.min(70, c.lat))];

const s = StyleSheet.create({
  hit: { position: 'absolute', alignItems: 'center', justifyContent: 'center' },
  pin: { borderWidth: 2, borderColor: '#fff' },
});

